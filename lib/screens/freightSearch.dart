import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frieghtmanage/screens/responsePage.dart';
import 'package:http/http.dart' as http;

class FreightSearchPage extends StatefulWidget {
  @override
  State<FreightSearchPage> createState() => _FreightSearchPageState();
}

class _FreightSearchPageState extends State<FreightSearchPage> {
  TextEditingController _controller = TextEditingController();
  TextEditingController ctrl = TextEditingController();
  List<String> _options = [];

  Future<void> _fetchSuggestions(String query) async {
    if (query.isEmpty) {
      setState(() {
        _options = [];
      });
      return;
    }

    final url =
        Uri.parse('http://universities.hipolabs.com/search?name=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      setState(() {
        _options = data.map<String>((uni) => uni['name'] as String).toList();
      });
    } else {
      setState(() {
        _options = [];
      });
      // throw Exception('Failed to load suggestions');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool _includeNearbyOriginPorts = false;

    return Scaffold(
      backgroundColor: Color(0xFFE6EAF8),

      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
              decoration: BoxDecoration(
                color: Color(0xFFF2F4FB), // Light background color
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Search the best Freight Rates',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                    },
                    child: Text(
                      'History',
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0139FF)),
                    ),
                    style: OutlinedButton.styleFrom(
                        side: BorderSide(color: Color(0xFF0139FF)),
                        backgroundColor: Color(0xFFE6EBFF)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Container(
                padding: EdgeInsets.only(top: 40.0, left: 20, right: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Autocomplete<String>(
                            optionsBuilder:
                                (TextEditingValue textEditingValue) async {
                              await _fetchSuggestions(textEditingValue.text);
                              return _options.where((option) => option
                                  .toLowerCase()
                                  .contains(
                                      textEditingValue.text.toLowerCase()));
                            },
                            displayStringForOption: (option) => option,
                            fieldViewBuilder: (context, controller, focusNode,
                                onFieldSubmitted) {
                              _controller.text =
                                  controller.text;
                              ctrl.text = controller.text;
                              return TextField(
                                controller: controller,
                                focusNode: focusNode,
                                decoration: InputDecoration(
                                    labelText: "Origin",
                                    labelStyle: TextStyle(color: Colors.grey[500]),
                                    border:
                                        OutlineInputBorder(), // Default border
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey[
                                            300]!,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey[
                                            400]!,
                                        width: 1.5,
                                      ),
                                    ),
                                    prefixIcon:
                                        Image.asset("assets/icons/location.png")
                                    // suffixIcon: suffixIcon != null ? suffixIcon : null,
                                    ),
                              );
                            },
                            onSelected: (String selection) {
                              _controller.text =
                                  selection;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Selected: $selection')),
                              );
                            },
                            optionsViewBuilder: (context, onSelected, options) {
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Material(
                                  color: Color(0xFFE6EAF8),
                                  elevation: 4.0,
                                  child: Container(
                                    width: 900,
                                    height: 500,
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: options.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final String option =
                                            options.elementAt(index);
                                        return ListTile(
                                          title: Text(option),
                                          onTap: () => onSelected(option),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Autocomplete<String>(
                            optionsBuilder:
                                (TextEditingValue textEditingValue) async {
                              await _fetchSuggestions(textEditingValue.text);
                              return _options.where((option) => option
                                  .toLowerCase()
                                  .contains(
                                      textEditingValue.text.toLowerCase()));
                            },
                            displayStringForOption: (option) => option,
                            fieldViewBuilder: (context, controller, focusNode,
                                onFieldSubmitted) {
                              _controller.text =
                                  controller.text;
                              return TextField(
                                controller: controller,
                                focusNode: focusNode,
                                decoration: InputDecoration(
                                    labelText: "Destination",
                                    labelStyle: TextStyle(color: Colors.grey[500]),
                                    border:
                                        OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey[
                                            300]!,
                                        width: 1.0,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.grey[
                                            400]!,
                                        width: 1.5,
                                      ),
                                    ),
                                    prefixIcon:
                                        Image.asset("assets/icons/location.png")
                                    // suffixIcon: suffixIcon != null ? suffixIcon : null,
                                    ),
                              );
                            },
                            onSelected: (String selection) {
                              _controller.text =
                                  selection;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Selected: $selection')),
                              );
                            },
                            optionsViewBuilder: (context, onSelected, options) {
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Material(
                                  color: Color(0xFFE6EAF8),
                                  elevation: 4.0,
                                  child: Container(
                                    width: 900,
                                    height: 500,
                                    child: ListView.builder(
                                      padding: EdgeInsets.zero,
                                      itemCount: options.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final String option =
                                            options.elementAt(index);
                                        return ListTile(
                                          title: Text(option),
                                          onTap: () => onSelected(option),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    // SizedBox(height: 3),
                    Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            title: Text("Include nearby origin ports"),
                            value: _includeNearbyOriginPorts,
                            onChanged: (value) {
                              setState(() {
                                _includeNearbyOriginPorts = value ?? false;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                        Expanded(
                          child: CheckboxListTile(
                            title: Text("Include nearby destination ports"),
                            value: false,
                            onChanged: (value) {},
                            controlAffinity: ListTileControlAffinity.leading,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                              label: "Commodity",
                              suffixIcon:
                                  Image.asset("assets/icons/Vector.png")),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildTextField(
                              label: "Cut Off Date",
                              suffixIcon:
                                  Image.asset("assets/icons/calendar-2.png")),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Text(
                      "Shipment Type:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      children: [
                        Row(
                          children: [
                            Checkbox(
                                value: true,
                                activeColor: Color(0xFF155EEF),
                                onChanged: (value) {}),
                            Text("FCL"),
                          ],
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Row(
                          children: [
                            Checkbox(value: false, onChanged: (value) {}),
                            Text("LCL"),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    Row(children: [
                      Expanded(
                        child: _buildTextField(
                            label: "Container Size",
                            initialValue: "40' Standard",
                            suffixIcon: Image.asset("assets/icons/Vector.png")),
                      ),

                      SizedBox(width: 16),
                      Expanded(
                          child: Row(children: [
                        Expanded(child: _buildTextField(label: "No of Boxes")),
                        SizedBox(width: 16),
                        Expanded(child: _buildTextField(label: "Weight (Kg)")),
                      ])),
                    ]),

                    SizedBox(height: 8),
                    Wrap(
                      children: [
                        Image.asset("assets/icons/info-circle.png"),
                        Text(
                          "   To obtain an accurate rate for spot rate with guaranteed space and booking, "
                          "please ensure your container count and weight per container are accurate.",
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Container Internal Dimensions:",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          spacing: 20,
                          children: [
                            Text("Length: 39.46 ft"),
                            Text("Width: 7.70 ft"),
                            Text("Height: 7.84 ft"),
                          ],
                        ),
                        SizedBox(
                          width: 66,
                        ),
                        SizedBox(
                            height: 100,
                            child: Image.asset("assets/images/container.png")),
                      ],
                    ),
                    SizedBox(height: 16),

                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.centerRight,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Color(0xFF0139FF)),
                            backgroundColor: Color(0xFFE6EBFF)),
                        onPressed: () {
                          final term = ctrl.text;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResponsePage(
                                        search: term,
                                      )));
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(top: 10.0, bottom: 4),
                          child: Wrap(
                            children: [
                              Image.asset("assets/icons/search-normal.png"),
                              Text(
                                "Search",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: Color(0xFF0139FF)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 26,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      {required String label,
      String? initialValue,
      Image? prefixIcon,
      Image? suffixIcon,
      TextEditingController? ctrl}) {
    return TextFormField(
      controller: ctrl,
      initialValue: initialValue,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[500]),
        border: OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey[300]!,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color:
                Colors.grey[400]!,
            width: 1.5,
          ),
        ),
        prefixIcon: prefixIcon != null ? prefixIcon : null,
        suffixIcon: suffixIcon != null ? suffixIcon : null,
      ),
    );
  }
}
