// controllers/purchase_controller.dart
import 'package:get/get.dart';
import 'package:rawaa_app/model/model_achat.dart';
import 'package:rawaa_app/styles/constants.dart';

class PurchaseController extends GetxController {
  List<MAchat> listeAchat = <MAchat>[];
  List<MAchat> listeFiltreAchat = <MAchat>[];


  String selectedFilter = "all";
  var _searchQuery = ''.obs;
  @override
  void onInit() {
    super.onInit();
    fetchData();

  }

  fetchData() async {
    await Constants.reposit.repGetAchats().then((value) {
      listeAchat = value['data']
          .map<MAchat>((e) => MAchat.fromJson(e))
          .toList();
      listeFiltreAchat = List.from(listeAchat);
      update();
    });
  }

  appliqueFilter() {
    switch (selectedFilter) {
      case 'all':
        listeFiltreAchat = List.from(listeAchat);
        break;
      case 'waiting':
        listeFiltreAchat = List.from(
          listeAchat.where((element) => element.status == 'waiting').toList(),
        );

        break;
      case 'confirmed':
        listeFiltreAchat = List.from(
          listeAchat.where((element) => element.status == 'confirmed').toList(),
        );

        break;
      case 'rejected':
        listeFiltreAchat = List.from(
          listeAchat.where((element) => element.status == 'rejected').toList(),
        );

        break;
      default:
    }
  }

  void setFilter(String status) {
    selectedFilter = status;
    appliqueFilter();
    update();
  }

  void setSearchQuery(String query) {
    _searchQuery.value = query;
    update();
  }

  void acceptRequest(int id) async {
    await Constants.reposit.repAccepteAchat(id).then((value) {
      if (value['status'] == 'success') {
        Constants.showSnackBar("Confirmation", "Achat accepté Avec succées");
        int index = listeAchat.indexWhere((element) => element.id == id);
        listeAchat[index] = listeAchat[index].copyWith(status1: "confirmed");
        appliqueFilter();
        update();
      }
    });
  }

  void refuseRequest(int id) async {
    await Constants.reposit.repRefuseAchat(id).then((value) {
      if (value['status'] == 'success') {
        Constants.showSnackBar("Confirmation", "Achat Rejeté Avec succées");
        int index = listeAchat.indexWhere((element) => element.id == id);

        listeAchat[index] = listeAchat[index].copyWith(status1: "rejected");
        appliqueFilter();

        update();
      }
    });
  }
}

// Extension pour copier l'objet avec de nouvelles valeurs
extension PurchaseRequestCopyWith on MAchat {
  MAchat copyWith({
    int? id,
    String? titleFormation,
    String? nameClient,
    double? price,
    String? nameFormateur,
    String? status1,
  }) {
    return MAchat(
      id: id ?? this.id,
      titleFormation: titleFormation ?? this.titleFormation,
      nameClient: nameClient ?? this.nameClient,
      price: price ?? this.price,
      nameFormateur: nameFormateur ?? this.nameFormateur,
      status: status1 ?? status,
      date: date,
      idClient: idClient,
      idFormation: idFormation,
    );
  }
}
