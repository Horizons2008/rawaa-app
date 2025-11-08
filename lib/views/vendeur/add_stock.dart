import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:rawaa_app/controller/controller_stock.dart';
import 'package:rawaa_app/model/model_categorie.dart';
import 'package:rawaa_app/model/model_product.dart';
import 'package:rawaa_app/model/model_stock.dart';
import 'package:rawaa_app/styles/constants.dart';

class AddStock extends StatelessWidget {
  const AddStock({super.key, this.selectedStock});
  final MStock? selectedStock;

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ControllerStock>(
      builder: (ctrl) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Add New Stock",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              SizedBox(height: 20),

              // Category Dropdown
              DropdownButtonFormField<MCat>(
                decoration: InputDecoration(
                  labelText: "Select Category",
                  border: OutlineInputBorder(),
                ),
                value: ctrl.selectedCat,
                items: ctrl.listeCat.map((cat) {
                  return DropdownMenuItem<MCat>(
                    value: cat,
                    child: Text(Constants.getTitle(cat.title, Constants.lang)),
                  );
                }).toList(),
                onChanged: (val) {
                  ctrl.changeCat(val!);
                },
              ),
              SizedBox(height: 16),

              // Product Dropdown
              DropdownButtonFormField<MProduct>(
                decoration: InputDecoration(
                  labelText: "Select Product",
                  border: OutlineInputBorder(),
                ),
                value: ctrl.selectedProd,
                items: ctrl.listeProd.map((prod) {
                  return DropdownMenuItem<MProduct>(
                    value: prod,
                    child: Text(prod.title),
                  );
                }).toList(),
                onChanged: (val) {
                  ctrl.selectedProd = val!;
                  ctrl.update();
                },
              ),
              SizedBox(height: 16),

              // Price TextField
              TextFormField(
                controller: ctrl.priceController,
                decoration: InputDecoration(
                  labelText: "Price",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.attach_money),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 16),

              // Quantity TextField
              TextFormField(
                controller: ctrl.qteController,
                decoration: InputDecoration(
                  labelText: "Quantity",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.countertops),
                ),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
              ),
              SizedBox(height: 16),

              // Images horizontal ListView
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Images",
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              SizedBox(height: 8),

              SizedBox(
                height: 90,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: ctrl.images.length + 1,
                  separatorBuilder: (_, __) => SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    if (index == ctrl.images.length) {
                      return GestureDetector(
                        onTap: () async {
                          // Use image picker logic here
                          ctrl.pickImageFromGallery();
                          //  setState(() {});
                        },
                        child: Container(
                          width: 75,
                          height: 75,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.blue),
                          ),
                          child: Icon(Icons.add_a_photo, color: Colors.blue),
                        ),
                      );
                    } else {
                      return Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              ctrl.images[index],

                              width: 75,
                              height: 75,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: 0,
                            right: 0,
                            child: GestureDetector(
                              onTap: () {
                                ctrl.images.removeAt(index);
                                ctrl.update();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.red,
                                ),
                                child: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Validate fields
                    ctrl.storeStock();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: ctrl.statusStore == ListeStatus.loading
                      ? const CircularProgressIndicator()
                      : Text(
                          "Store",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                ),
              ),
              SizedBox(height: 24),
            ],
          ),
        );
      },
    );
  }
}
