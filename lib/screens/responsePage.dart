import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResponsePage extends StatefulWidget {
  final String search;
  const ResponsePage({super.key, required this.search,});

  @override
  State<ResponsePage> createState() => _ResponsePageState();
}

class _ResponsePageState extends State<ResponsePage> {
  List<dynamic> _sources = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSources(widget.search);
  }

  Future<void> fetchSources(String query) async {
    final url = Uri.parse('http://universities.hipolabs.com/search?name=$query');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          _sources = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load sources!');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE6EAF8),
      appBar: AppBar(
        title: Text('Search Results'),
        backgroundColor: Color(0xFFF2F4FB),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _sources.isEmpty
              ? Center(
                  child: Text("No results found"),
                )
              : ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: _sources.length,
                  itemBuilder: (context, index) {
                    final source = _sources[index];
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 8.0),
                      child: ListTile(
                        title: Text(source['name']),
                        subtitle:
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            source['alpha_two_code'] != null ? Text("Alpha Two Code: "+source['alpha_two_code']) : SizedBox(),
                            Text('Website: '),
                            source['web_pages'][0] != null ? Text(source['web_pages'][0]) : SizedBox(),
                            source['web_pages'].length > 1 ? Text(source['web_pages'][1]) : SizedBox(),
                            source['state-province'] != null ? Text("State/province: "+source['state-province']) : SizedBox(),
                            source['country'] != null ? Text("Country: "+source['country']) : SizedBox(),
                            Text('Domains: '),
                            source['domains'][0] != null ? Text(source['domains'][0]) : SizedBox(),
                            source['domains'].length > 1 ? Text(source['domains'][1]) : SizedBox(),// Text(source['domains'][0])
                          ],
                        ),
                      ),
                    );
                  }),
    );
  }
}
