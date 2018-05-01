import 'package:flutter/material.dart';
import 'package:my_holiday/screen.dart';

final Screen natureScreen = new Screen(
    title: 'MY HOLIDAY',
    decorationImage: new DecorationImage(
        image: new AssetImage('images/cloud.jpg'),
        fit: BoxFit.cover
    ),
    widgetBuilder: (BuildContext context){
      return new ListView(
        children: [
          new _natureCard(
            natureImage: 'images/1.jpg',
            natureColor: Colors.red,
            natureCount: 201,
            natureTitle: 'Curug Sewu',
            natureDescription: 'Air Terjun yang menakjubkan',
          ),
          new _natureCard(
            natureImage: 'images/2.jpg',
            natureColor: Colors.yellowAccent,
            natureCount: 191,
            natureTitle: 'The Ranch',
            natureDescription: 'Rumah gaya monolitik',
          ),
          new _natureCard(
            natureImage: 'images/3.jpg',
            natureColor: Colors.blue,
            natureCount: 189,
            natureTitle: 'Danau Swarna',
            natureDescription: 'Danau Pelangi yang sejuk',
          ),
          new _natureCard(
            natureImage: 'images/4.jpg',
            natureColor: Colors.deepPurple,
            natureCount: 160,
            natureTitle: 'Sun Set',
            natureDescription: 'Bali Sunset dengan alam yang indah',
          ),
          new _natureCard(
            natureImage: 'images/5.jpg',
            natureColor: Colors.indigoAccent,
            natureCount: 120,
            natureTitle: 'Hutan Pringgodani',
            natureDescription: 'Pohon yang masih Asri',
          ),
        ],
      );
    }
);


class _natureCard extends StatelessWidget{

  final String natureImage;
  final Color natureColor;
  final int natureCount;
  final String natureTitle;
  final String natureDescription;

  _natureCard({
    this.natureImage,
    this.natureColor,
    this.natureCount,
    this.natureTitle,
    this.natureDescription
  });

  @override
  Widget build(BuildContext context) {

    return  new Padding(
      padding: const EdgeInsets.only(left:3.0,right: 3.0,bottom: 10.0),
      child: new Card(
        elevation: 10.0,
        child: new Column(
          children: [
            new Image.asset(
              natureImage,
              width: double.infinity,
              height: 150.0,
              fit: BoxFit.cover,
            ),
            new Row(
              children: [
                new Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: new Container(
                    child: new Icon(
                      Icons.streetview,
                      color: Colors.white,
                    ),
                    padding: const EdgeInsets.all(10.0),
                    decoration: new BoxDecoration(
                        color: natureColor,
                        borderRadius: new BorderRadius.all(const Radius.circular(15.0))
                    ),
                  ),
                ),
                new Expanded(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      new Text(
                        natureTitle,
                        style: new TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      new Text(
                        natureDescription,
                        style: new TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey
                        ),
                      )
                    ],
                  ),
                ),
                new Container(
                  width: 2.0,
                  height: 70.0,
                  decoration: new BoxDecoration(
                      gradient: new LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        stops: [0.1, 0.3,0.5, 0.7, 0.9],
                        colors: [
                          Colors.white,
                          Colors.white,
                          Colors.grey,
                          Colors.white,
                          Colors.white
                        ],

                      )
                  ),
                ),
                new Padding(
                  padding: const EdgeInsets.only(left:15.0,right:15.0),
                  child: new Column(
                    children: [
                      new Icon(Icons.favorite_border,color: Colors.red),
                      new Text(''+ natureCount.toString())
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );

  }
}
