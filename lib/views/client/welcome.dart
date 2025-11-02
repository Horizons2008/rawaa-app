import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rawaa_app/controller/welcome_controller.dart';

class ScreenWelcomClient extends StatelessWidget {
  const ScreenWelcomClient({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<WelcomeClientController>(
        init: WelcomeClientController(),
        builder: (ctrl) {
          // Dummy data for demonstration, replace with actual data/controller logic
          final String profileImage =
              'https://via.placeholder.com/120x120.png?text=User';
          final String userName = 'John Doe'; // replace with actual user
          final String userRole = 'Client'; // replace with actual role

          final List<Map<String, String>> categories = [
            {
              'image': 'https://via.placeholder.com/60x60.png?text=Cat1',
              'title': 'Catégorie 1',
            },
            {
              'image': 'https://via.placeholder.com/60x60.png?text=Cat2',
              'title': 'Catégorie 2',
            },
            {
              'image': 'https://via.placeholder.com/60x60.png?text=Cat3',
              'title': 'Catégorie 3',
            },
            {
              'image': 'https://via.placeholder.com/60x60.png?text=Cat4',
              'title': 'Catégorie 4',
            },
          ];

          final List<Map<String, dynamic>> products = [
            {
              'image': 'https://via.placeholder.com/100x100.png?text=Prod1',
              'title': 'Produit A',
              'price': 800,
              'qte': 3,
              'vendeur_name': 'VendeurX',
              'rating': 4.5,
            },
            {
              'image': 'https://via.placeholder.com/100x100.png?text=Prod2',
              'title': 'Produit B',
              'price': 650,
              'qte': 7,
              'vendeur_name': 'VendeurY',
              'rating': 3.8,
            },
            {
              'image': 'https://via.placeholder.com/100x100.png?text=Prod3',
              'title': 'Produit C',
              'price': 550,
              'qte': 1,
              'vendeur_name': 'VendeurX',
              'rating': 5,
            },
            {
              'image': 'https://via.placeholder.com/100x100.png?text=Prod4',
              'title': 'Produit D',
              'price': 310,
              'qte': 2,
              'vendeur_name': 'VendeurZ',
              'rating': 4,
            },
          ];

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Profile
                Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage(profileImage),
                    ),
                    SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 4),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            userRole,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blueGrey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Categories section
                Text(
                  'Catégories',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                SizedBox(
                  height: 110,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    separatorBuilder: (c, i) => SizedBox(width: 18),
                    itemBuilder: (context, idx) {
                      final cat = categories[idx];
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 76,
                            height: 76,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(18),
                              image: DecorationImage(
                                image: NetworkImage(cat['image']!),
                                fit: BoxFit.cover,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  blurRadius: 4,
                                  color: Colors.black12,
                                  offset: Offset(1, 2),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 7),
                          Text(
                            cat['title']!,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 32),

                // Products section
                Text(
                  'Produits',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 14),
                GridView.builder(
                  shrinkWrap: true,
                  itemCount: products.length,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.71,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 18,
                  ),
                  itemBuilder: (context, idx) {
                    final prod = products[idx];
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      padding: EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(13),
                            child: Image.network(
                              prod['image'],
                              height: 70,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            prod['title'],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Prix: ${prod['price'].toString()} DA',
                            style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.inventory_2,
                                size: 16,
                                color: Colors.orange,
                              ),
                              SizedBox(width: 3),
                              Text(
                                'Qté: ${prod['qte']}',
                                style: TextStyle(fontSize: 13),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.person, size: 14, color: Colors.grey),
                              SizedBox(width: 2),
                              Flexible(
                                child: Text(
                                  prod['vendeur_name'],
                                  style: TextStyle(fontSize: 13),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellow[700],
                                size: 15,
                              ),
                              SizedBox(width: 3),
                              Text(
                                prod['rating'].toString(),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
