import 'package:customerapp/core/Constant/themData.dart';
import 'package:customerapp/core/providers/categoryProvider.dart';
import 'package:customerapp/core/providers/serviceProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

typedef OnSelect = Function(String);

class FilterPage extends StatefulWidget {
  final FilterProvider filterState;

  const FilterPage({Key? key, required this.filterState}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  RangeValues _currentRangeValues = const RangeValues(40, 80);
  List<String> _selectedEventIds = [];
  List<String> _selectedServiceIds = [];
  List<String> _selectedCities = [];
  final List<String> _selectedSortOptions = [];
  bool _rangeSelected = false;
  String? _discount;

  @override
  void initState() {
    super.initState();
    _selectedEventIds = [...widget.filterState.categories];
    _selectedServiceIds = [...widget.filterState.services];
    _selectedCities = [...widget.filterState.cities];
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryProvider>(builder: (context, state, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Filters"),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const SizedBox(
                height: 20,
              ),
              /*--- Service Based on Price section ---*/
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      width: 0.5, color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue[100]!,
                      offset: const Offset(0, 2),
                      spreadRadius: 1,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 10),
                      child: Text(
                        "Services Based on Price",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                    CheckboxListTile(
                      title: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (!_selectedSortOptions.contains("High to Low")) {
                              _selectedSortOptions.add("High to Low");
                              _selectedSortOptions.remove("Low to High");
                            }
                          });
                        },
                        child: Text(
                          "High to Low",
                          style: TextStyle(
                            color: _selectedSortOptions.contains("High to Low")
                                ? Colors.blue
                                : Colors.black,
                            fontWeight:
                                _selectedSortOptions.contains("High to Low")
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                      ),
                      value: _selectedSortOptions.contains("High to Low"),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedSortOptions.add("High to Low");
                            _selectedSortOptions.remove("Low to High");
                          } else {
                            _selectedSortOptions.remove("High to Low");
                          }
                        });
                      },
                    ),
                    CheckboxListTile(
                      title: GestureDetector(
                        onTap: () {
                          setState(() {
                            if (!_selectedSortOptions.contains("Low to High")) {
                              _selectedSortOptions.add("Low to High");
                              _selectedSortOptions.remove("High to Low");
                            }
                          });
                        },
                        child: Text(
                          "Low to High",
                          style: TextStyle(
                            color: _selectedSortOptions.contains("Low to High")
                                ? Colors.blue
                                : Colors.black,
                            fontWeight:
                                _selectedSortOptions.contains("Low to High")
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                          ),
                        ),
                      ),
                      value: _selectedSortOptions.contains("Low to High"),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            _selectedSortOptions.add("Low to High");
                            _selectedSortOptions.remove("High to Low");
                          } else {
                            _selectedSortOptions.remove("Low to High");
                          }
                        });
                      },
                    ),
                  ],
                ),
              ),

              /*--- Services Section --*/
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      width: 0.5, color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue[100]!,
                      offset: const Offset(0, 2),
                      spreadRadius: 1,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Services",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: state.filterServices.map((e) {
                        bool isSelected =
                            _selectedServiceIds.contains(e.id.toString());

                        return ListTile(
                          trailing: Checkbox(
                            value: isSelected,
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  _selectedServiceIds.add(e.id.toString());
                                } else {
                                  _selectedServiceIds.remove(e.id.toString());
                                }
                              });
                            },
                          ),
                          title: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedServiceIds.remove(e.id.toString());
                                } else {
                                  _selectedServiceIds.add(e.id.toString());
                                }
                              });
                            },
                            child: Text(
                              e.service,
                              style: TextStyle(
                                color: isSelected ? Colors.blue : Colors.black,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              /*--- Events section ---*/
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      width: 0.5, color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue[100]!,
                      offset: const Offset(0, 2),
                      spreadRadius: 1,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Events",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: state.data.map((e) {
                        bool isSelected =
                            _selectedEventIds.contains(e.id.toString());

                        return ListTile(
                          trailing: Checkbox(
                            value: isSelected,
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  _selectedEventIds.add(e.id.toString());
                                } else {
                                  _selectedEventIds.remove(e.id.toString());
                                }
                              });
                            },
                          ),
                          title: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedEventIds.remove(e.id.toString());
                                } else {
                                  _selectedEventIds.add(e.id.toString());
                                }
                              });
                            },
                            child: Text(
                              e.name,
                              style: TextStyle(
                                color: isSelected ? Colors.blue : Colors.black,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              /*--- Cities Section --*/
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      width: 0.5, color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue[100]!,
                      offset: const Offset(0, 2),
                      spreadRadius: 1,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Cities",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: state.filterCities.map((e) {
                        bool isSelected =
                            _selectedCities.contains(e.city.toString());

                        return ListTile(
                          trailing: Checkbox(
                            value: isSelected,
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  _selectedCities.add(e.city.toString());
                                } else {
                                  _selectedCities.remove(e.city.toString());
                                }
                              });
                            },
                          ),
                          title: GestureDetector(
                            onTap: () {
                              setState(() {
                                if (isSelected) {
                                  _selectedCities.remove(e.city.toString());
                                } else {
                                  _selectedCities.add(e.city.toString());
                                }
                              });
                            },
                            child: Text(
                              e.city,
                              style: TextStyle(
                                color: isSelected ? Colors.blue : Colors.black,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),

              /*--- Price Section --*/
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                      width: 0.5, color: Theme.of(context).primaryColor),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue[100]!,
                      offset: const Offset(0, 2),
                      spreadRadius: 1,
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        "Select Price Range",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      onTap: () {
                        // Handle onTap if needed
                      },
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        RangeSlider(
                          values: _currentRangeValues,
                          min: 0,
                          max: 500000,
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
                  ],
                ),
              ),

              /*--- Apply Button --*/
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 150,
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).primaryColor),
                      onPressed: () {
                        if (_rangeSelected) {
                          widget.filterState.setFilters(
                              events: _selectedEventIds,
                              services: _selectedServiceIds,
                              cities: _selectedCities,
                              sortOptions: _selectedSortOptions,
                              startPrice: _currentRangeValues.start.toString(),
                              endPrice: _currentRangeValues.end.toString());
                        } else {
                          widget.filterState.setFilters(
                            events: _selectedEventIds,
                            services: _selectedServiceIds,
                            cities: _selectedCities,
                            sortOptions: _selectedSortOptions,
                          );
                        }
                        Navigator.pop(context);
                      },
                      child: const Text("Apply")),
                ),
              )
            ],
          ),
        ),
      );
    });
  }

  Widget filterTile(String title, {Function()? onTap, bool selected = false}) {
    return ListTile(
      onTap: onTap,
      title: Text(
        title,
        style: TextStyle(color: selected ? Colors.redAccent : Colors.black),
      ),
    );
  }
}


/* --- Service Based on Price -- */
/* 
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        width: 0.5, color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blue[100]!,
                          offset: const Offset(0, 2),
                          spreadRadius: 1,
                          blurRadius: 10)
                    ]),
                child: ListTile(
                  title: const Text(
                    "Services Based on Price",
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Theme.of(context).primaryColorDark)),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).primaryColorDark,
                      size: 20,
                    ),
                  ),
                  onTap: () {
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                "Services Based on Price",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Checkbox(
                                    value: _selectedSortOptions
                                        .contains("High to Low"),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          _selectedSortOptions
                                              .add("High to Low");
                                        } else {
                                          _selectedSortOptions
                                              .remove("High to Low");
                                        }
                                      });
                                    },
                                  ),
                                  title: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (_selectedSortOptions
                                            .contains("High to Low")) {
                                          _selectedSortOptions
                                              .remove("High to Low");
                                        } else {
                                          _selectedSortOptions
                                              .add("High to Low");
                                        }
                                      });
                                    },
                                    child: Text(
                                      "High to Low",
                                      style: TextStyle(
                                        color: _selectedSortOptions
                                                .contains("High to Low")
                                            ? Colors.blue
                                            : Colors.black,
                                        fontWeight: _selectedSortOptions
                                                .contains("High to Low")
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                                ListTile(
                                  leading: Checkbox(
                                    value: _selectedSortOptions
                                        .contains("Low to High"),
                                    onChanged: (bool? value) {
                                      setState(() {
                                        if (value == true) {
                                          _selectedSortOptions
                                              .add("Low to High");
                                        } else {
                                          _selectedSortOptions
                                              .remove("Low to High");
                                        }
                                      });
                                    },
                                  ),
                                  title: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        if (_selectedSortOptions
                                            .contains("Low to High")) {
                                          _selectedSortOptions
                                              .remove("Low to High");
                                        } else {
                                          _selectedSortOptions
                                              .add("Low to High");
                                        }
                                      });
                                    },
                                    child: Text(
                                      "Low to High",
                                      style: TextStyle(
                                        color: _selectedSortOptions
                                                .contains("Low to High")
                                            ? Colors.blue
                                            : Colors.black,
                                        fontWeight: _selectedSortOptions
                                                .contains("Low to High")
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ), 
              */

/*--- Services Section --*/
 /*  Container(
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        width: 0.5, color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blue[100]!,
                          offset: const Offset(0, 2),
                          spreadRadius: 1,
                          blurRadius: 10)
                    ]),
                child: ListTile(
                  title: const Text(
                    "Services",
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Theme.of(context).primaryColorDark)),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).primaryColorDark,
                      size: 20,
                    ),
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (BuildContext context,
                              StateSetter setModalState) {
                            return Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text(
                                        "Select Services",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(),
                                Expanded(
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Column(
                                      children: state.filterServices.map((e) {
                                        bool isSelected = _selectedServiceIds
                                            .contains(e.id.toString());

                                        return ListTile(
                                          leading: Checkbox(
                                            value: isSelected,
                                            onChanged: (bool? value) {
                                              setModalState(() {
                                                if (value == true) {
                                                  _selectedServiceIds
                                                      .add(e.id.toString());
                                                } else {
                                                  _selectedServiceIds
                                                      .remove(e.id.toString());
                                                }
                                              });
                                            },
                                          ),
                                          title: GestureDetector(
                                            onTap: () {
                                              setModalState(() {
                                                if (isSelected) {
                                                  _selectedServiceIds
                                                      .remove(e.id.toString());
                                                } else {
                                                  _selectedServiceIds
                                                      .add(e.id.toString());
                                                }
                                              });
                                            },
                                            child: Text(
                                              e.service,
                                              style: TextStyle(
                                                color: isSelected
                                                    ? Colors.blue
                                                    : Colors.black,
                                                fontWeight: isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ), 
              */

 /*--- Events section ---*/

              /* 
              Container(
                margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        width: 0.5, color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blue[100]!,
                          offset: const Offset(0, 2),
                          spreadRadius: 1,
                          blurRadius: 10)
                    ]),
                child: ListTile(
                  title: const Text(
                    "Events",
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Theme.of(context).primaryColorDark)),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).primaryColorDark,
                      size: 20,
                    ),
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (BuildContext context,
                              StateSetter setModalState) {
                            return Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text(
                                        "Select Events",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(),
                                Expanded(
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Column(
                                      children: state.data.map((e) {
                                        bool isSelected = _selectedEventIds
                                            .contains(e.id.toString());

                                        return ListTile(
                                          leading: Checkbox(
                                            value: isSelected,
                                            onChanged: (bool? value) {
                                              setModalState(() {
                                                if (value == true) {
                                                  _selectedEventIds
                                                      .add(e.id.toString());
                                                } else {
                                                  _selectedEventIds
                                                      .remove(e.id.toString());
                                                }
                                              });
                                            },
                                          ),
                                          title: GestureDetector(
                                            onTap: () {
                                              setModalState(() {
                                                if (isSelected) {
                                                  _selectedEventIds
                                                      .remove(e.id.toString());
                                                } else {
                                                  _selectedEventIds
                                                      .add(e.id.toString());
                                                }
                                              });
                                            },
                                            child: Text(
                                              e.name,
                                              style: TextStyle(
                                                color: isSelected
                                                    ? Colors.blue
                                                    : Colors.black,
                                                fontWeight: isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );

                   
                  },
                ),
              ), 
              */
  /* showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        context: context,
                        builder: (context) {
                          return Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Text(
                                      "Select Categories",
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: primaryColor),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(),
                              Expanded(
                                child: SingleChildScrollView(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Column(
                                    children: state.data
                                        .map((e) => filterTile(e.name,
                                                onTap: () {
                                              setState(() {
                                                if (_selectedCategoryIds
                                                    .contains(
                                                        e.id.toString())) {
                                                  _selectedCategoryIds
                                                      .remove(e.id.toString());
                                                } else {
                                                  _selectedCategoryIds
                                                      .add(e.id.toString());
                                                }
                                              });
                                              Navigator.pop(context);
                                            },
                                                selected: _selectedCategoryIds
                                                    .contains(e.id.toString())))
                                        .toList(),
                                  ),
                                ),
                              ),
                            ],
                          );
                        });
                        */

/*--- Cities Section --*/

/* 

Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        width: 0.5, color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blue[100]!,
                          offset: const Offset(0, 2),
                          spreadRadius: 1,
                          blurRadius: 10)
                    ]),
                child: ListTile(
                  title: const Text(
                    "Cities",
                    style: TextStyle(fontSize: 18),
                  ),
                  trailing: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Theme.of(context).primaryColorDark)),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).primaryColorDark,
                      size: 20,
                    ),
                  ),
                  onTap: () {
                    showModalBottomSheet(
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                      ),
                      context: context,
                      builder: (context) {
                        return StatefulBuilder(
                          builder: (BuildContext context,
                              StateSetter setModalState) {
                            return Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: const [
                                      Text(
                                        "Select Cities",
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Divider(),
                                Expanded(
                                  child: SingleChildScrollView(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: Column(
                                      children: state.filterCities.map((e) {
                                        bool isSelected = _selectedCities
                                            .contains(e.city.toString());

                                        return ListTile(
                                          leading: Checkbox(
                                            value: isSelected,
                                            onChanged: (bool? value) {
                                              setModalState(() {
                                                if (value == true) {
                                                  _selectedCities
                                                      .add(e.city.toString());
                                                } else {
                                                  _selectedCities.remove(
                                                      e.city.toString());
                                                }
                                              });
                                            },
                                          ),
                                          title: GestureDetector(
                                            onTap: () {
                                              setModalState(() {
                                                if (isSelected) {
                                                  _selectedCities.remove(
                                                      e.city.toString());
                                                } else {
                                                  _selectedCities
                                                      .add(e.city.toString());
                                                }
                                              });
                                            },
                                            child: Text(
                                              e.city,
                                              style: TextStyle(
                                                color: isSelected
                                                    ? Colors.blue
                                                    : Colors.black,
                                                fontWeight: isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),

 */

 /*--- Price Section --*/
/* 
Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                        width: 0.5, color: Theme.of(context).primaryColor),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.blue[100]!,
                          offset: const Offset(0, 2),
                          spreadRadius: 1,
                          blurRadius: 10)
                    ]),
                child: ListTile(
                  title: const Text("Price"),
                  trailing: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Theme.of(context).primaryColorDark)),
                    child: Icon(
                      Icons.arrow_forward_ios,
                      color: Theme.of(context).primaryColorDark,
                      size: 20,
                    ),
                  ),
                  onTap: () {
                    showModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              height: 200,
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(
                                    "Select Price Range",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  RangeSlider(
                                    values: _currentRangeValues,
                                    min: 0,
                                    max: 500000,
                                    divisions: 10,
                                    labels: RangeLabels(
                                      _currentRangeValues.start
                                          .round()
                                          .toString(),
                                      _currentRangeValues.end
                                          .round()
                                          .toString(),
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
                          });
                        });
                  },
                ),
              ),


 */

