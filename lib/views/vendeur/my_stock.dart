import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:rawaa_app/controller/controller_stock.dart';
import 'package:rawaa_app/my_widgets/error_restful.dart';
import 'package:rawaa_app/my_widgets/loading.dart';
import 'package:rawaa_app/model/model_stock.dart';
import 'package:rawaa_app/styles/constants.dart';
import 'package:rawaa_app/views/vendeur/add_stock.dart';

class MyStock extends StatelessWidget {
  const MyStock({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<ControllerStock>(
        init: ControllerStock(),
        builder: (ctrl) {
          return ctrl.status == ListeStatus.loading
              ? WidgetLoading()
              : ctrl.status == ListeStatus.error
              ? WidgetError()
              : Column(
                  children: [
                    // Header Section
                    _buildHeader(context),

                    // Search Bar Section
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      child: _buildSearchBar(ctrl),
                    ),

                    // Stock List Section
                    Expanded(
                      child: ctrl.filteredList.isEmpty
                          ? _buildEmptyState()
                          : _buildStockList(ctrl),
                    ),
                  ],
                );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add new stock item
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (context) {
              
              List<String> images = [];
              // For demo: Static lists for categories & products -- in real use, you would fetch with a controller.
             
             
              // For this demonstration, you can replace above lists with your dynamic data

             

              void selectImages() async {
                // For illustration only; in real use, use ImagePicker or similar.
                // This demo just adds a dummy path.
                if (images.length < 5) {
                  images.add("assets/default_img.png");
                }
                // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                (context as Element).markNeedsBuild();
              }

              return Padding(
                padding: EdgeInsets.only(
                  // Make sheet fit above keyboard
                  bottom: MediaQuery.of(context).viewInsets.bottom,
                  left: 20,
                  right: 20,
                  top: 32,
                ),
                child: StatefulBuilder(
                  builder: (context, setState) {
                    // You may want to fetch categories & products here if dynamic
                    return AddStock();
                  },
                ),
              );
            },
          );
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20,
        MediaQuery.of(context).padding.top,
        20,
        20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.menu, color: Colors.grey[800]),
            onPressed: () {
              // TODO: Implement navigation drawer or back
              Navigator.pop(context);
            },
          ),
          Expanded(
            child: Text(
              'Products',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.add, color: Colors.white, size: 24),
            ),
            onPressed: () {
              Constants.showSnackBar(null, "Add new product");
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ControllerStock ctrl) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: ctrl.searchController,
        decoration: InputDecoration(
          hintText: "Search by product or vendor...",
          hintStyle: TextStyle(color: Colors.grey[500], fontSize: 15),
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildStockList(ControllerStock ctrl) {
    return ListView.builder(
      padding: EdgeInsets.only(bottom: 80),
      itemCount: ctrl.filteredList.length,
      itemBuilder: (context, index) {
        MStock stock = ctrl.filteredList[index];
        return _buildStockItem(stock);
      },
    );
  }

  Widget _buildStockItem(MStock stock) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,

        children: [
          // Product Image
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[200],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                "${Constants.photoUrl}/product/${stock.productId}.jpg",
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Constants.primaryColor.withOpacity(0.3),
                          Constants.primaryColor.withOpacity(0.1),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.inventory_2,
                        size: 30,
                        color: Constants.primaryColor,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(width: 16),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name
                Text(
                  stock.productTitle,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4),

                // Vendor Name
                /*  Text(
                  "By ${stock.vendeurName}",
                  style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 6),*/

                // Quantity Tag
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    "Qty: ${stock.qte.toStringAsFixed(0)}",
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: 12),

          // Price
          Text(
            "\$${stock.price.toStringAsFixed(2)}",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey[400]),
          SizedBox(height: 20),
          Text(
            "No Products Found",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            "Try adjusting your search or add a new product.",
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
