import 'package:flutter/material.dart';

import 'package:movies/src/widgets/card_swiper_widget.dart';
import 'package:movies/src/providers/movies_provider.dart';
import 'package:movies/src/widgets/movie_horizontal.dart';
import 'package:movies/src/search/search_delegate.dart';

class HomePage extends StatelessWidget {

  final moviesProvider = new MoviesProvider();

  @override
  Widget build(BuildContext context) {

    moviesProvider.getPopulars();

    return Scaffold(
      appBar: AppBar(
        title: Text('Jetzt spielen'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DataSearch(),
                //query: 'Hola'
              );
            },
          )
        ]
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _cardSwiper(),
            _footer(context)
          ],
        ),
      )
    );
  }

  Widget _cardSwiper() {
    return FutureBuilder(
      future: moviesProvider.getOnTheaters(),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return CardSwiper(
            movies: snapshot.data,
          );
        } else {
          return Container(
            height: 400.0,
            child: Center(
              child: CircularProgressIndicator()
            ),
          );
        }
        
      },
    );
  }

  Widget _footer(BuildContext context) {
    return Container(
      width: double.infinity,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20.0),
            child: Text(
              'Beliebt',
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ),
          SizedBox(height: 10.0),
          StreamBuilder(
            stream: moviesProvider.popularsStream,
            builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
              if (snapshot.hasData) {
                return MovieHorizontal(movies: snapshot.data, nextPage: moviesProvider.getPopulars);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}