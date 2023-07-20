import 'package:customerapp/core/providers/categoryProvider.dart';
import 'package:customerapp/core/providers/serviceProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
typedef OnSelect = Function(String) ;
class FilterPage extends StatefulWidget {
  final FilterProvider filterState;
  const FilterPage({Key? key,required this.filterState}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  RangeValues _currentRangeValues = const RangeValues(40, 80);
  List<String> _selectedCategoryIds=[];
  bool _rangeSelected = false;
  String? _discount;
  @override
  void initState() {
    super.initState();
    _selectedCategoryIds = [...widget.filterState.categories];
    _discount = widget.filterState.discount;
  }
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
                  children: state.data.map((e) => filterTile(e.name,
                      onTap: (){
                  setState(() {
                    if(_selectedCategoryIds.contains(e.id.toString())){
                      _selectedCategoryIds.remove(e.id.toString());
                    }
                    else{
                      _selectedCategoryIds.add(e.id.toString());
                    }
                  });
                    },selected: _selectedCategoryIds.contains(e.id.toString()))).toList()
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
                          _rangeSelected = true;
                          _currentRangeValues = values;
                        });
                      },
                    ),
                  ],
                ),
                ExpansionTile(
                    title: const Text("Discount"),
                    children: [
                      filterTile("10%",selected: _discount=="10",onTap: (){
                        setState(() {
                          _discount = "10";
                        });
                      }),
                      filterTile("20%",selected: _discount=="20",onTap: (){
                        setState(() {
                          _discount = "20";
                        });
                      }),
                      filterTile("30%",selected: _discount=="30",onTap: (){
                        setState(() {
                          _discount = "30";
                        });
                      }),
                      filterTile("40%",selected: _discount=="40",onTap: (){
                        setState(() {
                          _discount = "40";
                        });
                      }),
                      filterTile("50%",selected: _discount=="50",onTap: (){
                        setState(() {
                          _discount = "50";
                        });
                      }),
                      ],
                ),
                ElevatedButton(
                    onPressed: (){
                      if(_rangeSelected){
                        widget.filterState.setFilters(categories: _selectedCategoryIds,discount: _discount,startPrice: _currentRangeValues.start.toString(),endPrice: _currentRangeValues.end.toString());
                      }
                      else{
                        widget.filterState.setFilters(categories: _selectedCategoryIds,discount: _discount);
                      }
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
  Widget filterTile(String title,{Function()? onTap,bool selected=false}){
    return ListTile(
      onTap: onTap,
      title: Text(title,style: TextStyle(color: selected?Colors.redAccent:Colors.black),),
    );
  }
}
