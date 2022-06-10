import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/favourite_service.dart';


class FavouritePage extends StatefulWidget {
  const FavouritePage({Key? key}) : super(key: key);

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {

  double? userInput;

  String? resultMessage;

  void convert(double value, double conversionRate) {
    var result = value * conversionRate;

    if (result == 0) {
      resultMessage = "Can't Perform the conversion";
    } else {
      resultMessage = "${result.toString()} ";
    }
    setState(() {
      resultMessage = resultMessage;
    });
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Column(
            children: <Widget>[
            SizedBox(
            height: 80.0,
            width: 400.0,
            child: Center(
              child: Text("My Favourite",
                  style: GoogleFonts.comfortaa(
                    color: Colors.grey,
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                  )),
            ),
          ),
              Expanded(child:
              FutureBuilder<List<FavouriteData>>(
                  future: DataBaseHelper.instance.getFavourites(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<FavouriteData>> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child:  Text('Loading...'));
                    }
                    return ListView(
                      children: snapshot.data!.map((favourite) {
                        return Center(
                          child: ExpansionTile(
                            title: Text('${favourite.fromUnit} -> ${favourite.toUnit}',
                              style: GoogleFonts.comfortaa(
                                  color: Color(0xFF616161), fontSize: 18),
                            ),
                            children: [
                              Column(
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          height: 50,
                                          width: 280,
                                          child: TextField(
                                            onChanged: (text) {
                                              var input = double.tryParse(text);
                                              if (input != null) {
                                                setState(() {
                                                  resultMessage = text;
                                                }
                                                );
                                              }
                                            },
                                            decoration: InputDecoration(
                                              contentPadding: const EdgeInsets.all(10),
                                              hintText: "Enter a value to convert",
                                              hintStyle: GoogleFonts.comfortaa(
                                                  color: Colors.grey, fontSize: 18),
                                              border: const OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                    style: BorderStyle.none,
                                                    width: 0,
                                                  )),
                                            ),
                                            keyboardType: TextInputType.number,
                                          ),
                                        ),
                                        RawMaterialButton(
                                            onPressed: () {
                                              if (userInput == 0){
                                                return;
                                              }else{
                                                convert(userInput!, favourite.conversionRate);
                                                //print("converted");
                                              }
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.grey,
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              alignment: AlignmentDirectional.center,
                                              width: 100,
                                              height: 30,
                                              child: Text(
                                                "Convert",
                                                style: GoogleFonts.comfortaa(
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 14,
                                                    color: Colors.white),
                                              ),
                                            )),
                                      ],
                                    ),
                                    Text(
                                      (resultMessage.toString() == "null")
                                          ? ""
                                          : resultMessage.toString(),
                                      style: GoogleFonts.comfortaa(
                                          fontSize: 20, fontWeight: FontWeight.w900),
                                    )

                                  ]
                              )
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  }),
              )

            ],
          )


        ),
      ),
    );
  }
}
