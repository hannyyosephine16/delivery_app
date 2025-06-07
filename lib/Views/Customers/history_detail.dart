import 'package:flutter/material.dart';
import 'package:delivery_app/Common/global_style.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:delivery_app/Models/order.dart';
import 'package:delivery_app/Models/driver.dart';
import 'package:delivery_app/Views/Component/order_status_card.dart';
import 'package:delivery_app/Services/order_service.dart';
import 'package:delivery_app/Services/driver_service.dart';
import 'package:delivery_app/Services/image_service.dart';
import 'package:delivery_app/Services/tracking_service.dart';
import '../../Models/order_enum.dart';
import 'cart_screen.dart';
import 'home_cust.dart';
import 'rating_cust.dart';
import 'history_cust.dart';

class HistoryDetailPage extends StatefulWidget {
  static const String route = "/Customers/HistoryDetailPage";

  final Order order;

  const HistoryDetailPage({
    Key? key,
    required this.order,
  }) : super(key: key);

  @override
  State<HistoryDetailPage> createState() => _HistoryDetailPageState();
}

class _HistoryDetailPageState extends State<HistoryDetailPage> with TickerProviderStateMixin {
  late List<AnimationController> _cardControllers;
  late List<Animation<Offset>> _cardAnimations;

  bool _isLoading = false;
  bool _hasGivenRating = false;
  String? _errorMessage;

  // Driver details
  Driver? _driver;
  bool _isLoadingDriver = false;

  @override
  void initState() {
    super.initState();

    // Set initial rating status
    _hasGivenRating = widget.order.hasGivenRating;

    // Initialize animation controllers for each card section
    _cardControllers = List.generate(
      5, // Number of card sections (added 1 for status card)
          (index) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 600 + (index * 200)),
      ),
    );

    // Create slide animations for each card
    _cardAnimations = _cardControllers.map((controller) {
      return Tween<Offset>(
        begin: const Offset(0, -0.5),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: controller,
        curve: Curves.easeOutCubic,
      ));
    }).toList();

    // Start animations sequentially
    Future.delayed(const Duration(milliseconds: 100), () {
      for (var controller in _cardControllers) {
        controller.forward();
      }
    });

    // Load driver details if available
    if (widget.order.driverId != null) {
      _loadDriverDetails(widget.order.driverId.toString());
    }

    // Refresh order details to get the latest data
    _refreshOrderDetails();
  }

  // Fetch latest order details from the API
  Future<void> _refreshOrderDetails() async {
    try {
      final orderData = await OrderService.getOrderById(widget.order.id);
      if (mounted) {
        setState(() {
          // Update tracking status if available
          if (orderData['tracking'] != null) {
            // We can't modify the original order object, so we'll just update the UI state
            _hasGivenRating = orderData['has_given_rating'] ?? widget.order.hasGivenRating;
          }
        });
      }
    } catch (e) {
      print('Error refreshing order details: $e');
      // Don't set error message to avoid disrupting the UI
    }
  }

  // Load driver details
  Future<void> _loadDriverDetails(String driverId) async {
    if (_isLoadingDriver) return;

    setState(() {
      _isLoadingDriver = true;
    });

    try {
      final driverData = await DriverService.getDriverById(driverId);
      final driver = Driver.fromJson(driverData);

      if (mounted) {
        setState(() {
          _driver = driver;
          _isLoadingDriver = false;
        });
      }
    } catch (e) {
      print('Error loading driver details: $e');
      if (mounted) {
        setState(() {
          _isLoadingDriver = false;
        });
      }
    }
  }

  // Submit rating to the API
  Future<void> _submitRating(int storeRating, String? storeComment, int driverRating, String? driverComment) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final success = await OrderService.reviewOrder(
        widget.order.id,
        storeRating: storeRating,
        storeComment: storeComment,
        driverRating: driverRating,
        driverComment: driverComment,
      );

      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasGivenRating = success;
        });
      }
    } catch (e) {
      print('Error submitting rating: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to submit rating. Please try again.';
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    for (var controller in _cardControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildCard({required Widget child, required int index}) {
    return SlideTransition(
      position: _cardAnimations[index < _cardAnimations.length ? index : 0],
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: child,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final String formattedOrderDate = DateFormat('dd MMM yyyy, hh.mm a').format(widget.order.orderDate);

    // Get driver information from either the driver object or tracking
    final String driverName = _driver?.name ??
        widget.order.tracking?.driverName ??
        'Driver belum ditugaskan';

    final String vehicleNumber = _driver?.vehicleNumber ??
        widget.order.tracking?.vehicleNumber ??
        '-';

    final String? driverImageUrl = _driver?.avatar ??
        widget.order.tracking?.driverImageUrl;

    // Get driver rating
    final double driverRating = _driver?.rating ?? 4.8;

    return Scaffold(
      backgroundColor: const Color(0xffD6E6F2),
      appBar: AppBar(
        elevation: 0.5,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(7.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: GlobalStyle.primaryColor, width: 1.0),
            ),
            child: Icon(Icons.arrow_back_ios_new, color: GlobalStyle.primaryColor, size: 18),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Detail Pesanan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
            fontFamily: GlobalStyle.fontFamily,
          ),
        ),
        actions: [
          if (widget.order.code != null && widget.order.code!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Center(
                child: Text(
                  '#${widget.order.code}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: GlobalStyle.primaryColor,
                    fontFamily: GlobalStyle.fontFamily,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: GlobalStyle.primaryColor))
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Status Card
              if (widget.order.tracking != null)
                OrderStatusCard(
                  order: widget.order,
                  animation: _cardAnimations[0],
                ),

              // Order Date Section
              _buildCard(
                index: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.calendar_today, color: GlobalStyle.primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'Tanggal Pesanan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: GlobalStyle.fontColor,
                            fontFamily: GlobalStyle.fontFamily,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      formattedOrderDate,
                      style: TextStyle(
                        color: GlobalStyle.fontColor,
                        fontFamily: GlobalStyle.fontFamily,
                      ),
                    ),
                    if (widget.order.status != null)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: _getStatusColor(widget.order.status).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Text(
                                _getStatusText(widget.order.status),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: _getStatusColor(widget.order.status),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // Delivery Address Section
              _buildCard(
                index: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.location_on, color: GlobalStyle.primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'Alamat Pengiriman',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: GlobalStyle.fontColor,
                            fontFamily: GlobalStyle.fontFamily,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.order.deliveryAddress,
                      style: TextStyle(
                        color: GlobalStyle.fontColor,
                        fontFamily: GlobalStyle.fontFamily,
                      ),
                    ),
                  ],
                ),
              ),

              // Driver Information Section
              _buildDriverInfo(driverName, vehicleNumber, driverImageUrl, driverRating),

              // Store and Items Section
              _buildCard(
                index: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.store, color: GlobalStyle.primaryColor),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            widget.order.store.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: GlobalStyle.fontColor,
                              fontFamily: GlobalStyle.fontFamily,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ...widget.order.items.map((item) => _buildOrderItem(
                      item.name,
                      item.imageUrl,
                      item.quantity,
                      item.price.toInt(),
                    )),
                  ],
                ),
              ),

              // Payment Details Section
              _buildCard(
                index: 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.payment, color: GlobalStyle.primaryColor),
                        const SizedBox(width: 8),
                        Text(
                          'Rincian Pembayaran',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: GlobalStyle.fontColor,
                            fontFamily: GlobalStyle.fontFamily,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildPaymentRow('Subtotal untuk Produk', widget.order.subtotal.toInt()),
                    _buildPaymentRow('Biaya Layanan', widget.order.serviceCharge.toInt()),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(thickness: 1),
                    ),
                    _buildTotalPaymentRow(widget.order.total.toInt()),
                  ],
                ),
              ),

              // Action Buttons
              const SizedBox(height: 16),
              _hasGivenRating
                  ? _buildBuyAgainButton()
                  : _buildActionButtons(driverName, vehicleNumber),
            ],
          ),
        ),
      ),
    );
  }

  // Buy Again button only
  Widget _buildBuyAgainButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamedAndRemoveUntil(
            context,
            HomePage.route,
                (route) => false,
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: GlobalStyle.primaryColor,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: const Text(
          'Beli Lagi',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // Both buttons (Buy Again + Rate)
  Widget _buildActionButtons(String driverName, String vehicleNumber) {
    // Only show rating button for completed or delivered orders
    final bool canRate = widget.order.status == OrderStatus.completed ||
        widget.order.status == OrderStatus.delivered;

    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                HomePage.route,
                    (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: GlobalStyle.primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              side: BorderSide(color: GlobalStyle.primaryColor),
            ),
            child: const Text(
              'Beli Lagi',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        if (canRate) ...[
          const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RatingCustomerPage(
                      order: widget.order, // Pass the required 'order' parameter
                    ),
                  ),
                ).then((result) {
                  // Handle the result from rating page
                  if (result != null && result is Map<String, dynamic>) {
                    // Submit the rating to the API
                    _submitRating(
                      result['storeRating'] ?? 5,
                      result['storeComment'],
                      result['driverRating'] ?? 5,
                      result['driverComment'],
                    );
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: GlobalStyle.primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
              ),
              child: const Text(
                'Beri Rating',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildOrderItem(String name, String imageUrl, int quantity, int price) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: GlobalStyle.borderColor),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: ImageService.displayImage(
              imageSource: imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              placeholder: Container(
                width: 60,
                height: 60,
                color: Colors.grey[200],
                child: const Icon(Icons.restaurant_menu, color: Colors.grey),
              ),
              errorWidget: Container(
                width: 60,
                height: 60,
                color: Colors.grey[300],
                child: const Icon(Icons.image_not_supported, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: GlobalStyle.fontColor,
                    fontFamily: GlobalStyle.fontFamily,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: GlobalStyle.lightColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'x$quantity',
                    style: TextStyle(
                      color: GlobalStyle.primaryColor,
                      fontFamily: GlobalStyle.fontFamily,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text(
            NumberFormat.currency(
              locale: 'id',
              symbol: 'Rp ',
              decimalDigits: 0,
            ).format(price),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: GlobalStyle.fontColor,
              fontFamily: GlobalStyle.fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentRow(String label, int amount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: GlobalStyle.fontColor,
              fontFamily: GlobalStyle.fontFamily,
            ),
          ),
          Text(
            NumberFormat.currency(
              locale: 'id',
              symbol: 'Rp ',
              decimalDigits: 0,
            ).format(amount),
            style: TextStyle(
              color: GlobalStyle.fontColor,
              fontFamily: GlobalStyle.fontFamily,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalPaymentRow(int amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Total Pembayaran',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: GlobalStyle.fontColor,
            fontFamily: GlobalStyle.fontFamily,
          ),
        ),
        Text(
          NumberFormat.currency(
            locale: 'id',
            symbol: 'Rp ',
            decimalDigits: 0,
          ).format(amount),
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: GlobalStyle.primaryColor,
            fontFamily: GlobalStyle.fontFamily,
          ),
        ),
      ],
    );
  }

  Widget _buildDriverInfo(String driverName, String vehicleNumber, String? driverImageUrl, double driverRating) {
    final bool hasDriver = widget.order.driverId != null || widget.order.tracking != null;
    final bool isActiveOrder = widget.order.status != OrderStatus.completed &&
        widget.order.status != OrderStatus.cancelled;

    return _buildCard(
      index: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.delivery_dining, color: GlobalStyle.primaryColor),
              const SizedBox(width: 8),
              Text(
                'Informasi Driver',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: GlobalStyle.fontColor,
                  fontFamily: GlobalStyle.fontFamily,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          hasDriver
              ? Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: ClipOval(
                  child: driverImageUrl != null && driverImageUrl.isNotEmpty
                      ? ImageService.displayImage(
                    imageSource: driverImageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    placeholder: Center(
                      child: Icon(
                        Icons.person,
                        size: 30,
                        color: Colors.grey[400],
                      ),
                    ),
                  )
                      : Center(
                    child: Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driverName,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: GlobalStyle.fontColor,
                        fontFamily: GlobalStyle.fontFamily,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.motorcycle, color: Colors.grey[600], size: 16),
                        const SizedBox(width: 4),
                        Text(
                          vehicleNumber,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          driverRating.toString(),
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          )
              : Center(
            child: Text(
              'Driver belum ditugaskan',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
                fontFamily: GlobalStyle.fontFamily,
              ),
            ),
          ),

          // Only show buttons if order has driver and status is still in progress
          if (hasDriver && isActiveOrder && _driver != null)
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.call, color: Colors.white),
                      label: const Text(
                        'Hubungi',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: GlobalStyle.primaryColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => _callDriver(_driver?.phoneNumber),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.message, color: Colors.white),
                      label: const Text(
                        'Pesan',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[600],
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () => _messageDriver(_driver?.phoneNumber),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // Call driver using url_launcher
  void _callDriver(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nomor telepon driver tidak tersedia'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final Uri uri = Uri.parse('tel:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak dapat memulai panggilan'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Message driver using url_launcher with SMS
  void _messageDriver(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Nomor telepon driver tidak tersedia'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final Uri uri = Uri.parse('sms:$phoneNumber');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Tidak dapat memulai pesan'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // Get status color based on order status
  Color _getStatusColor(OrderStatus status) {
    if (status == OrderStatus.completed || status == OrderStatus.delivered) {
      return Colors.green;
    } else if (status == OrderStatus.cancelled) {
      return Colors.red;
    } else if (status == OrderStatus.on_delivery ||
        status == OrderStatus.driverHeadingToCustomer) {
      return Colors.blue;
    } else if (status == OrderStatus.preparing ||
        status == OrderStatus.driverAtStore) {
      return Colors.orange;
    } else {
      return Colors.blue.shade300; // Default for other statuses
    }
  }

  // Get human-readable status text
  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.completed:
        return 'Selesai';
      case OrderStatus.delivered:
        return 'Terkirim';
      case OrderStatus.cancelled:
        return 'Dibatalkan';
      case OrderStatus.pending:
        return 'Menunggu';
      case OrderStatus.approved:
        return 'Disetujui';
      case OrderStatus.preparing:
        return 'Diproses';
      case OrderStatus.on_delivery:
        return 'Diantar';
      case OrderStatus.driverAssigned:
        return 'Driver Ditugaskan';
      case OrderStatus.driverHeadingToStore:
        return 'Driver Menuju Toko';
      case OrderStatus.driverAtStore:
        return 'Driver Di Toko';
      case OrderStatus.driverHeadingToCustomer:
        return 'Driver Menuju Anda';
      case OrderStatus.driverArrived:
        return 'Driver Tiba';
      default:
        return 'Diproses';
    }
  }
}