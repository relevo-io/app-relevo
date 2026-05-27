import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/offer_model.dart';
import '../services/offer_service.dart';
import 'auth_provider.dart';

part 'offers_provider.g.dart';

@riverpod
Future<List<Offer>> offers(Ref ref) async {
  final offerService = ref.watch(offerServiceProvider);
  return offerService.getOffers();
}

@riverpod
Future<List<Offer>> myOffers(Ref ref) async {
  final allOffers = await ref.watch(offersProvider.future);
  final user = ref.watch(authProvider).value;
  if (user == null) return [];
  return allOffers.where((offer) => offer.owner == user.id).toList();
}
