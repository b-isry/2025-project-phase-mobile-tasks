import 'package:flutter/material.dart';
import 'package:task_6/core/theme/app_theme.dart';
import 'package:task_6/features/product/models/product.dart';
import 'package:task_6/features/product/presentation/widgets/product_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  RangeValues _currentPriceRange = const RangeValues(20, 80); // Example range

  void _showFilterModal() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Category',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Category',
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                         borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Price',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  // Slider
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: AppTheme.primaryColor,
                      inactiveTrackColor: Colors.grey[200],
                      thumbColor: Colors.white, // This seems to be a range slider in design
                      rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 12, elevation: 4),
                    ),
                    child: RangeSlider(
                      values: _currentPriceRange,
                      min: 0,
                      max: 1000, // Assumption
                      onChanged: (RangeValues values) {
                        setState(() {
                          _currentPriceRange = values;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: AppTheme.primaryColor,
                         shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('APPLY', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Product'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Leather',
                      suffixIcon: Icon(Icons.arrow_forward, color: AppTheme.primaryColor),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                GestureDetector(
                  onTap: _showFilterModal,
                  child: Container(
                    height: 56, // Match TextField height
                    width: 56,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.filter_list, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                itemCount: Product.dummyProducts.length,
                separatorBuilder: (context, index) => const SizedBox(height: 24),
                itemBuilder: (context, index) {
                  return ProductCard(
                    product: Product.dummyProducts[index],
                    onTap: () {
                       Navigator.pushNamed(
                          context,
                          '/details',
                          arguments: Product.dummyProducts[index],
                        );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

