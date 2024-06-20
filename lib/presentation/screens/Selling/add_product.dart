import 'package:flutter/material.dart';
import 'package:style_sphere/presentation/screens/Selling/api_service.dart';

class SellingPage extends StatefulWidget {
  const SellingPage({super.key});

  @override
  _SellingPageState createState() => _SellingPageState();
}

class _SellingPageState extends State<SellingPage> {
  final ApiService _apiService = ApiService();
  final List<String> _imagePaths = [];
  bool showSizeAndComments = false;
  Set<String> selectedCategoriesCategory = <String>{};
  Set<String> selectedCategoriesSeason = <String>{};
  Set<String> selectedCategoriesColor = <String>{};
  Set<String> selectedCategoriesCondition = <String>{};
  Set<String> selectedCategoriesMaterial = <String>{};
  Set<String> selectedCategoriesHowMany = <String>{};
  String? selectedSeason;
  String? selectedCondition;
  bool manySelected = false;
  bool imagesUploaded = false;

  void toggleSizeAndComments() {
    setState(() {
      showSizeAndComments = !showSizeAndComments;
    });
  }

  void toggleCategory(String category, String sectionLabel) {
    setState(() {
      switch (sectionLabel) {
        case 'Category':
          if (selectedCategoriesCategory.contains(category)) {
            selectedCategoriesCategory.remove(category);
          } else {
            selectedCategoriesCategory.add(category);
          }
          break;
        case 'Season':
          selectedSeason = selectedSeason == category ? null : category;
          break;
        case 'Color':
          if (selectedCategoriesColor.contains(category)) {
            selectedCategoriesColor.remove(category);
          } else {
            selectedCategoriesColor.add(category);
          }
          break;
        case 'Condition':
          selectedCondition = selectedCondition == category ? null : category;
          break;
        case 'Material':
          if (selectedCategoriesMaterial.contains(category)) {
            selectedCategoriesMaterial.remove(category);
          } else {
            selectedCategoriesMaterial.add(category);
          }
          break;
        case 'How Many Pieces':
          if (category == 'Many') {
            manySelected = true;
            selectedCategoriesHowMany.clear();
            selectedCategoriesHowMany.add('Many');
          } else if (category == 'One') {
            manySelected = false;
            selectedCategoriesHowMany.clear();
            selectedCategoriesHowMany.add('One');
          }
          break;
        default:
          break;
      }
    });
  }

  void validateImagesUploaded() async {
    await _apiService.uploadImages(_imagePaths);
    setState(() {
      imagesUploaded = true;
    });
  }

  void uploadItem() async {
    if (!imagesUploaded) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please upload images'),
        ),
      );
      return;
    }

    final productData = {
      'category': selectedCategoriesCategory.toList(),
      'season': selectedSeason,
      'color': selectedCategoriesColor.toList(),
      'condition': selectedCondition,
      'material': selectedCategoriesMaterial.toList(),
      'how_many': selectedCategoriesHowMany.toList(),
      // Add other product details here
    };

    await _apiService.uploadProduct(productData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selling'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Post your item',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Upload Up To 10 Images*'),
                          IconButton(
                            icon: const Icon(Icons.arrow_forward_ios),
                            onPressed: validateImagesUploaded,
                            color: Colors.cyan.shade600,
                          ),
                        ],
                      ),
                      Center(
                        child: Column(
                          children: [
                            Image.network(
                              'https://placehold.co/100x100',
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'Upload Images',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      if (!imagesUploaded)
                        const Text(
                          'Please upload images*',
                          style: TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              buildTextField('Price', 'Enter the price you wish this item for',
                  isRequired: true),
              const Divider(),
              buildCategorySection(
                'Category',
                [
                  'Topwear',
                  'Bottomwear',
                  'Watches',
                  'Socks',
                  'Shoes',
                  'Belts',
                  'Flip Flops',
                  'Bags',
                  'Innerwear',
                  'Sandal',
                  'Shoe Accessories',
                  'Fragrance',
                  'Jewellery',
                  'Lips',
                  'Saree',
                  'Eyewear',
                  'Nails',
                  'Scarves',
                  'Dress',
                  'Loungewear and Nightwear',
                  'Wallets',
                  'Apparel Set',
                  'Headwear',
                  'Mufflers',
                  'Skin Care',
                  'Makeup',
                  'Free Gifts',
                  'Ties',
                  'Accessories',
                  'Skin',
                  'Beauty Accessories',
                  'Water Bottle',
                  'Eyes',
                  'Bath and Body',
                  'Gloves',
                  'Sports Accessories',
                  'Cufflinks',
                  'Sports Equipment',
                  'Stoles',
                  'Hair',
                  'Perfumes',
                  'Home Furnishing',
                  'Umbrellas',
                  'Wristbands',
                  'Vouchers',
                ],
                isRequired: true,
              ),
              const Divider(),
              buildCategorySection(
                'Season',
                ['Fall', 'Summer', 'Winter', 'Spring'],
              ),
              const Divider(),
              buildCategorySection(
                'Color',
                [
                  'Pink',
                  'Red',
                  'Yellow',
                  'White',
                  'Gray',
                  'Blue',
                  'Purple',
                  'Black',
                  'Green',
                  'Orange',
                  'Brown',
                ],
              ),
              const Divider(),
              buildCategorySection(
                'Condition',
                ['New', 'Used'],
                isRequired: true,
              ),
              const Divider(),
              buildCategorySection(
                'Material',
                [
                  'Cotton',
                  'Silk',
                  'Denim',
                  'Wool',
                  'Linen',
                  'Leather',
                  'Shirts',
                  'Jeans',
                  'Watches',
                  'Track Pants',
                  'T-shirts',
                  'Socks',
                  'Casual Shoes',
                  'Belts',
                  'Flip Flops',
                  'Handbags',
                  'Tops',
                  'Bra',
                  'Sandals',
                  'Shoe Accessories',
                  'Sweatshirts',
                  'Deodorant',
                  'Formal Shoes',
                  'Bracelet',
                  'Lipstick',
                  'Flats',
                  'Kurtas',
                  'Waistcoat',
                  'Sports Shoes',
                  'Shorts',
                  'Briefs',
                  'Sarees',
                  'Perfume and Body Mist',
                  'Heels',
                  'Sunglasses',
                  'Innerwear Vests',
                  'Pendant',
                  'Nail Polish',
                  'Laptop Bag',
                  'Scarves',
                  'Rain Jacket',
                  'Dresses',
                  'Night suits',
                  'Skirts',
                  'Wallets',
                  'Blazers',
                  'Ring',
                  'Kurta Sets',
                  'Clutches',
                  'Shrug',
                  'Backpacks',
                  'Caps',
                  'Trousers',
                  'Earrings',
                  'Camisoles',
                  'Boxers',
                  'Jewellery Set',
                  'Dupatta',
                  'Capris',
                  'Lip Gloss',
                  'Bath Robe',
                  'Mufflers',
                  'Tunics',
                  'Jackets',
                  'Trunk',
                  'Lounge Pants',
                  'Face Wash and Cleanser',
                  'Necklace and Chains',
                  'Duffel Bag',
                  'Sports Sandals',
                  'Foundation and Primer',
                  'Sweaters',
                  'Free Gifts',
                  'Trolley Bag',
                  'Tracksuits',
                  'Swimwear',
                  'Shoe Laces',
                  'Fragrance Gift Set',
                  'Bangle',
                  'Nightdress',
                  'Ties',
                  'Baby Dolls',
                  'Leggings',
                  'Highlighter and Blush',
                  'Travel Accessory',
                  'Kurtis',
                  'Mobile Pouch',
                  'Messenger Bag',
                  'Lip Care',
                  'Face Moisturisers',
                  'Compact',
                  'Eye Cream',
                  'Accessory Gift Set',
                  'Beauty Accessory',
                  'Jumpsuit',
                  'Kajal and Eyeliner',
                  'Water Bottle',
                  'Suspenders',
                  'Lip Liner',
                  'Robe',
                  'Salwar and Dupatta',
                  'Patiala',
                  'Stockings',
                  'Eyeshadow',
                  'Headband',
                  'Tights',
                  'Nail Essentials',
                  'Churidar',
                  'Lounge T-shirts',
                  'Face Scrub and Exfoliator',
                  'Lounge Shorts',
                  'Gloves',
                  'Mask and Peel',
                  'Wristbands',
                  'Tablet Sleeve',
                  'Ties and Cufflinks',
                  'Footballs',
                  'Stoles',
                  'Shapewear',
                  'Nehru Jackets',
                  'Salwar',
                  'Cufflinks',
                  'Jeggings',
                  'Hair Colour',
                  'Concealer',
                  'Rompers',
                  'Body Lotion',
                  'Sunscreen',
                  'Booties',
                  'Waist Pouch',
                  'Hair Accessory',
                  'Rucksacks',
                  'Basketballs',
                  'Lehenga Choli',
                  'Clothing Set',
                  'Mascara',
                  'Toner',
                  'Cushion Covers',
                  'Key chain',
                  'Makeup Remover',
                  'Lip Plumper',
                  'Umbrellas',
                  'Face Serum and Gel',
                  'Hat',
                  'Mens Grooming Kit',
                  'Rain Trousers',
                  'Body Wash and Scrub',
                  'Suits',
                  'iPad',
                ],
                isRequired: true,
              ),
              const Divider(),
              buildCategorySection(
                'How Many Pieces',
                ['One', 'Many'],
                isRequired: true,
              ),
              const Divider(),
              if (manySelected || showSizeAndComments) ...[
                buildTextField('Size', 'Enter the size of this item',
                    isRequired: true),
                const Divider(),
                buildTextField(
                    'Number of Comments', 'Enter the number of comments',
                    isRequired: true),
                const Divider(),
              ],
              buildTextField('Item Title', 'Enter a title for this item',
                  isRequired: true),
              const Divider(),
              buildTextField('Description', 'Write a description on this item',
                  isTextArea: true, isRequired: true),
              const Divider(),
              ElevatedButton(
                onPressed: uploadItem,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.cyan.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Center(
                  child: Text('Upload Item'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(String label, String placeholder,
      {bool isTextArea = false, bool isRequired = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label + (isRequired ? '*' : ''),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 8),
        isTextArea
            ? TextField(
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: placeholder,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFF00ACC1),
                    ),
                  ),
                  contentPadding: const EdgeInsets.all(12),
                ),
              )
            : TextField(
                decoration: InputDecoration(
                  hintText: placeholder,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(
                      color: Color(0xFF00ACC1),
                    ),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                ),
              ),
      ],
    );
  }

  Widget buildCategorySection(String label, List<String> categories,
      {bool isRequired = false}) {
    Set<String> selectedSet;
    switch (label) {
      case 'Category':
        selectedSet = selectedCategoriesCategory;
        break;
      case 'Season':
        selectedSet = selectedCategoriesSeason;
        break;
      case 'Color':
        selectedSet = selectedCategoriesColor;
        break;
      case 'Condition':
        selectedSet = selectedCategoriesCondition;
        break;
      case 'Material':
        selectedSet = selectedCategoriesMaterial;
        break;
      case 'How Many Pieces':
        selectedSet = selectedCategoriesHowMany;
        break;
      default:
        selectedSet = Set<String>(); // Default empty set
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label + (isRequired ? '*' : ''),
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: categories
              .map((category) => buildCategoryChip(
                  label, category, selectedSet.contains(category)))
              .toList(),
        ),
      ],
    );
  }

  Widget buildCategoryChip(String sectionLabel, String label, bool isSelected) {
    Color chipColor = isSelected ? Colors.cyan.shade600 : Colors.grey.shade300;
    Color textColor = isSelected ? Colors.white : Colors.black;

    return GestureDetector(
      onTap: () {
        toggleCategory(label, sectionLabel);
      },
      child: Chip(
        label: Text(
          label,
          style: TextStyle(color: textColor),
        ),
        backgroundColor: chipColor.withOpacity(1.0),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
    );
  }
}
