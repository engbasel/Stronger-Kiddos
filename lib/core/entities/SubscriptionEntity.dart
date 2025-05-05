// ignore_for_file: file_names

class SubscriptionEntity {
  final DateTime? subscriptionStartDate;
  final DateTime? subscriptionEndDate;
  final List<String>? purchasedServices;
  final List<String>? availableServices;

  SubscriptionEntity({
    this.subscriptionStartDate,
    this.subscriptionEndDate,
    this.purchasedServices,
    this.availableServices,
  });
}
