import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawaa_app/controller/welcome_controller.dart';
import 'package:rawaa_app/model/model_stock.dart';
import 'package:rawaa_app/styles/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailScreen extends StatefulWidget {
  final MStock stock;

  const ProductDetailScreen({super.key, required this.stock});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentPage = 0;

  bool get _hasFiche =>
      widget.stock.ficheTechniquePath != null &&
      widget.stock.ficheTechniquePath!.isNotEmpty;

  bool get _isPdf =>
      widget.stock.ficheTechniquePath?.toLowerCase().endsWith('.pdf') ?? false;

  String get _ficheUrl =>
      '${Constants.photoUrl}stock/fiches/${widget.stock.ficheTechniquePath}';

  Future<void> _openFiche() async {
    if (!_hasFiche) return;

    if (_isPdf) {
      // Open PDF in external browser / PDF viewer
      final uri = Uri.parse(_ficheUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        Constants.showSnackBar('Erreur', 'Impossible d\'ouvrir le fichier');
      }
    } else {
      // Show image in a full-screen dialog
      showDialog(
        context: context,
        builder: (_) => Dialog(
          backgroundColor: Colors.black,
          insetPadding: EdgeInsets.all(0),
          child: Stack(
            children: [
              InteractiveViewer(
                child: Center(
                  child: Image.network(
                    _ficheUrl,
                    fit: BoxFit.contain,
                    loadingBuilder: (ctx, child, progress) {
                      if (progress == null) return child;
                      return Center(child: CircularProgressIndicator());
                    },
                    errorBuilder: (_, __, ___) => Center(
                      child: Icon(
                        Icons.broken_image,
                        color: Colors.white,
                        size: 64,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    padding: EdgeInsets.all(6),
                    child: Icon(Icons.close, color: Colors.white, size: 22),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  String _getLocalizedTitle(dynamic titleData) {
    if (titleData == null) return '—';
    if (titleData is Map) {
      return titleData[Constants.lang] ??
          titleData['fr'] ??
          titleData['ar'] ??
          titleData['en'] ??
          '—';
    }
    return titleData.toString();
  }

  void _showVendeurDetail() {
    final stock = widget.stock;
    final String wilayaName = _getLocalizedTitle(stock.vendeurWilaya);
    final String communeName = _getLocalizedTitle(stock.vendeurCommune);
    final bool hasPhone =
        stock.vendeurPhone != null && stock.vendeurPhone!.isNotEmpty;
    final bool hasPic =
        stock.vendeurPicture != null && stock.vendeurPicture!.isNotEmpty;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      backgroundColor: Colors.white,
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Drag handle ─────────────────────
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            SizedBox(height: 16),

            // ── Profile header ──────────────────
            CircleAvatar(
              radius: 40,
              backgroundColor: Constants.primaryColor.withOpacity(0.12),
              backgroundImage: hasPic
                  ? NetworkImage('${Constants.baseUrl}${stock.vendeurPicture}')
                  : null,
              child: hasPic
                  ? null
                  : Icon(Icons.person, size: 42, color: Constants.primaryColor),
            ),
            SizedBox(height: 12),
            Text(
              stock.vendeurName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 4),
            if (hasPhone)
              Text(
                stock.vendeurPhone!,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            SizedBox(height: 16),

            // ── Info cards ──────────────────────
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.location_city_rounded,
                    label: 'wilaya'.tr,
                    value: wilayaName,
                  ),
                  SizedBox(height: 10),
                  _InfoRow(
                    icon: Icons.map_outlined,
                    label: 'commune'.tr,
                    value: communeName,
                  ),
                  SizedBox(height: 10),
                  _InfoRow(
                    icon: Icons.phone_outlined,
                    label: 'phone_number'.tr,
                    value: hasPhone ? stock.vendeurPhone! : '—',
                  ),
                ],
              ),
            ),
            SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: Column(
                children: [
                  _InfoRow(
                    icon: Icons.category_outlined,
                    label: 'select_categorie'.tr,
                    value: stock.catTitle,
                  ),
                  SizedBox(height: 10),
                  _InfoRow(
                    icon: Icons.inventory_2_outlined,
                    label: 'select_product'.tr,
                    value: stock.productTitle,
                  ),
                  SizedBox(height: 10),
                  _InfoRow(
                    icon: Icons.production_quantity_limits,
                    label: 'qte'.tr,
                    value: '${stock.qte.toStringAsFixed(0)}',
                  ),
                ],
              ),
            ),
            SizedBox(height: 18),

            // ── Action buttons ──────────────────
            if (hasPhone)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final uri = Uri.parse('tel:${stock.vendeurPhone}');
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        }
                      },
                      icon: Icon(Icons.phone, size: 18),
                      label: Text('appeler'.tr),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () async {
                        final uri = Uri.parse(
                          'https://wa.me/${stock.vendeurPhone}',
                        );
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(
                            uri,
                            mode: LaunchMode.externalApplication,
                          );
                        }
                      },
                      icon: Icon(Icons.message, size: 18),
                      label: Text('whatsapp'.tr),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF25D366),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'detail_product'.tr,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: GetBuilder<WelcomeClientController>(
        builder: (ctrl) {
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Image Slider ────────────────────────────────────────
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 16),
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[100],
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Stack(
                      children: [
                        CarouselSlider.builder(
                          itemCount: widget.stock.images.length,
                          itemBuilder: (context, index, realIndex) {
                            return Image.network(
                              "${Constants.photoUrl}stock/${widget.stock.images[index]}",
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Icon(
                                Icons.image_not_supported,
                                size: 60,
                                color: Colors.grey,
                              ),
                            );
                          },
                          options: CarouselOptions(
                            height: 250,
                            viewportFraction: 1.0,
                            autoPlay: widget.stock.images.length > 1,
                            autoPlayInterval: Duration(milliseconds: 2500),
                            onPageChanged: (index, _) {
                              setState(() => _currentPage = index);
                            },
                          ),
                        ),
                        if (widget.stock.images.length > 1)
                          Positioned(
                            bottom: 10,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                widget.stock.images.length,
                                (i) => AnimatedContainer(
                                  duration: Duration(milliseconds: 300),
                                  margin: EdgeInsets.symmetric(horizontal: 4),
                                  width: _currentPage == i ? 14 : 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: _currentPage == i
                                        ? Constants.primaryColor
                                        : Colors.grey.withOpacity(0.5),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  // ── Title & Price ────────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.stock.productTitle,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              widget.stock.catTitle,
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'prix'.tr,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            Constants.currency(widget.stock.price),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Constants.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 14),

                  // ── Description ─────────────────────────────────────────
                  Text(
                    'description'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      border: Border.all(color: Colors.grey[200]!),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      widget.stock.description,
                      style: TextStyle(
                        fontSize: 13,
                        height: 1.6,
                        color: Colors.grey[800],
                      ),
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  SizedBox(height: 16),

                  // ── Action Buttons Row: Vendeur + Fiche ─────────────────
                  Row(
                    children: [
                      // Vendeur Detail Button
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _showVendeurDetail,
                          icon: Icon(
                            Icons.store_rounded,
                            color: Constants.primaryColor,
                            size: 18,
                          ),
                          label: Text(
                            'detail_vendeur'.tr,
                            style: TextStyle(color: Constants.primaryColor),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Constants.primaryColor),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      // Fiche Technique Button
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _hasFiche ? _openFiche : null,
                          icon: Icon(
                            _isPdf
                                ? Icons.picture_as_pdf_rounded
                                : Icons.description_rounded,
                            color: _hasFiche ? Colors.deepOrange : Colors.grey,
                            size: 18,
                          ),
                          label: Text(
                            'fiche_technique'.tr,
                            style: TextStyle(
                              color: _hasFiche
                                  ? Colors.deepOrange
                                  : Colors.grey,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: _hasFiche
                                  ? Colors.deepOrange
                                  : Colors.grey[300]!,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // ── Quantity selector ────────────────────────────────────
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'qte'.tr,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              Icons.remove_circle_outline,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              if (ctrl.qte > 1) {
                                ctrl.qte--;
                                ctrl.total = ctrl.qte * widget.stock.price;
                                ctrl.update();
                              }
                            },
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              ctrl.qte.toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.add_circle_outline,
                              color: Colors.green,
                            ),
                            onPressed: () {
                              ctrl.qte++;
                              ctrl.total = ctrl.qte * widget.stock.price;
                              ctrl.update();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),

                  // ── Total & Add to Cart ──────────────────────────────────
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'total'.tr,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          Constants.currency(ctrl.total),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton.icon(
                      onPressed: () => ctrl.addToCart(widget.stock),
                      icon: Icon(Icons.shopping_cart_checkout_rounded),
                      label: Text(
                        'add_to_cart'.tr,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Small helper row widget for bottom sheet info
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18, color: Colors.grey[600]),
        SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: TextStyle(fontSize: 13, color: Colors.black87),
              children: [
                TextSpan(
                  text: '$label: ',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
                TextSpan(text: value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
