import 'package:customerapp/core/providers/categoryProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
typedef OnSelect = Function(String) ;
class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  RangeValues _currentRangeValues = const RangeValues(40, 80);

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(
      builder: (context,state,child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Filters"),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ExpansionTile(
                    title: const Text("Categories"),
                  children: state.data.map((e) => filterTile(e.name)).toList()
                ),
                ExpansionTile(
                    title: const Text("Price"),
                  children: [
                    RangeSlider(
                      values: _currentRangeValues,
                      max: 100000,
                      divisions: 10,
                      labels: RangeLabels(
                        _currentRangeValues.start.round().toString(),
                        _currentRangeValues.end.round().toString(),
                      ),
                      onChanged: (RangeValues values) {
                        setState(() {
                          _currentRangeValues = values;
                        });
                      },
                    ),
                  ],
                ),
                ExpansionTile(
                    title: const Text("Discount"),
                    children: [
                      filterTile("10%"),
                      filterTile("20%"),
                      filterTile("30%"),
                      filterTile("40%"),
                      filterTile("50%"),
                    ],
                ),
                ExpansionTile(title: const Text("Other"),
                  children: [
                    filterTile("A"),
                    filterTile("B"),
                  ],
                ),
                ExpansionTile(title: const Text("Location"),
                  children: [
                    filterTile("Kolkata"),
                    filterTile("Bangalore"),
                    filterTile("Haryana"),
                    filterTile("Delhi"),
                    filterTile("Mumbai"),
                  ],
                ),
                ElevatedButton(
                    onPressed: (){
                      Navigator.pop(context);
                    },
                    child: const Text("Apply"))
              ],
            ),
          ),
        );
      }
    );
  }
  Widget filterTile(String title,{Function()? onTap}){
    return ListTile(
      onTap: onTap,
      title: Text(title),
    );
  }
}
