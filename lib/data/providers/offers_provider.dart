import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/offer_model.dart';
import '../services/offer_service.dart';

part 'offers_provider.g.dart';

@riverpod
Future<List<Offer>> offers(Ref ref) async {
  final offerService = ref.watch(offerServiceProvider);
  return offerService.getOffers();
}
