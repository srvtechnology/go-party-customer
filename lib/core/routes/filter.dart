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
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const SizedBox(height: 20,),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 0.5,color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue[100]!,
                        offset: const Offset(0,2),
                        spreadRadius: 1,
                        blurRadius: 10
                      )
                    ]
                  ),
                  child: ListTile(
                      title: const Text("Categories",style: TextStyle(fontSize: 18),),
                      trailing: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Theme.of(context).primaryColorDark)
                        ),
                        child: Icon(Icons.arrow_forward_ios,color: Theme.of(context).primaryColorDark,size: 20,),
                      ),
                    onTap: (){
                        showModalBottomSheet(
                            shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            context: context, builder: (context){
                           return Column(
                             children:  state.data.map((e) => filterTile(e.name,
                                 onTap: (){
                                   setState(() {
                                     if(_selectedCategoryIds.contains(e.id.toString())){
                                       _selectedCategoryIds.remove(e.id.toString());
                                     }
                                     else{
                                       _selectedCategoryIds.add(e.id.toString());
                                     }
                                   });
                                   Navigator.pop(context);
                                 },selected: _selectedCategoryIds.contains(e.id.toString()))).toList(),
                           );
                        });
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 0.5,color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.blue[100]!,
                            offset: const Offset(0,2),
                            spreadRadius: 1,
                            blurRadius: 10
                        )
                      ]
                  ),
                  child: ListTile(
                      title: const Text("Price"),
                    trailing: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Theme.of(context).primaryColorDark)
                      ),
                      child: Icon(Icons.arrow_forward_ios,color: Theme.of(context).primaryColorDark,size: 20,),
                    ),
                      onTap: (){
                        showModalBottomSheet(
                            shape:  RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            context: context, builder: (context){
                            return StatefulBuilder(
                              builder: (context,setState) {
                                return Container(
                                  padding:const EdgeInsets.symmetric(horizontal: 20),
                                  height: 200,
                                  child: Column(
                                    children: [
                                      const SizedBox(height: 20,),
                                      const Text("Select Price Range",style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
                                      const SizedBox(height: 20,),
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
                                );
                              }
                            );
                        });
                      },
                  ),
                ),
                Container(
                  width: 150,
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor),
                      onPressed: (){
                        if(_rangeSelected){
                          widget.filterState.setFilters(categories: _selectedCategoryIds,startPrice: _currentRangeValues.start.toString(),endPrice: _currentRangeValues.end.toString());
                        }
                        else{
                          widget.filterState.setFilters(categories: _selectedCategoryIds);
                        }
                        Navigator.pop(context);
                      },
                      child: const Text("Apply")),
                )
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
