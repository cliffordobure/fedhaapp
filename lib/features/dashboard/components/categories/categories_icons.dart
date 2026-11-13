import 'package:flutter/material.dart';

IconData getMaterialIcon(String categoryName) {
  switch (categoryName) {
    case "Grocery Shopping":
      return Icons.shopping_cart_outlined;
    case "Transport":
      return Icons.directions_bus_filled;
    case "Entertainment":
      return Icons.movie_outlined;
    case "Groceries":
      return Icons.local_grocery_store_outlined;
    case "Upkeep":
      return Icons.inventory_2_outlined;
    case "Airbnb":
      return Icons.home_outlined;
    case "Electricity":
      return Icons.flashlight_on_outlined;
    case "School fees":
      return Icons.school_outlined;
    case "savings":
      return Icons.monetization_on_outlined;
    case "Household":
      return Icons.house_outlined;
    case "Internet":
      return Icons.wifi_outlined;
    case "Rent":
      return Icons.monetization_on_outlined;
    case "Clothes":
      return Icons.person_2_outlined;

    default:
      return Icons.help_outline;
  }
}
