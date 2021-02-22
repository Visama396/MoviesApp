import 'package:flutter/material.dart';
import 'package:movies/src/models/actor_model.dart';
import 'package:movies/src/models/movie_model.dart';
import 'package:movies/src/providers/movies_provider.dart';

class MovieDetail extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final Movie movie = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _createAppBar(movie),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 20.0,),
                _posterTitle(context, movie),
                _description(movie),
                _description(movie),
                _description(movie),
                _description(movie),
                _description(movie),
                _description(movie),
                _description(movie),
                _showCast(movie),
              ]
            ),
          ),
        ],
      ),
    );
  }

  Widget _showCast(Movie movie) {
    final movieProvider = new MoviesProvider();
    
    return FutureBuilder(
      future: movieProvider.getCast(movie.id),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return _createCastPageView(snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _createCastPageView(List<Actor> actors) {
    return SizedBox(
      height: 200.0,
      child: PageView.builder(
        pageSnapping: false,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1
        ),
        itemCount: actors.length,
        itemBuilder: (BuildContext context, int index) => _actorCard(actors[index]),
      ),
    );
  }

  Widget _actorCard(Actor actor) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              image: NetworkImage(actor.getProfile()),
              placeholder: AssetImage('assets/img/no-image.jpg'),
              height: 150.0,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 5.0,),
          Text(
            actor.name,
            overflow: TextOverflow.ellipsis
          )
        ]
      ),
    );
  }

  Widget _posterTitle(BuildContext context, Movie movie) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Hero(
            tag: movie.uniqueId,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20.0),
              child: Image(
                image: NetworkImage(movie.getPosterImg()),
                height: 160.0,
              ),
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(movie.title, style: Theme.of(context).textTheme.headline6, overflow: TextOverflow.ellipsis,),
                Text(movie.originalTitle, style: Theme.of(context).textTheme.subtitle1, overflow: TextOverflow.ellipsis),
                Row(
                  children: <Widget>[
                    Icon (Icons.star_border),
                    Text(movie.voteAverage.toString(), style: Theme.of(context).textTheme.subtitle1),
                  ],
                ),
              ]
            ),
          ),
        ],
      ),
    );
  }

  Widget _description(Movie movie) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: Text(movie.overview, textAlign: TextAlign.justify,),
    );
  }

  Widget _createAppBar(Movie movie) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigoAccent,
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: FadeInImage(
          image: NetworkImage(movie.getBackdropImg()),
          placeholder: AssetImage('assets/img/loading.gif'),
          fit: BoxFit.cover,
        ),
        centerTitle: true, 
        title: Text(
          movie.title,
          style: TextStyle(color: Colors.white, fontSize: 16.0),
          )
      ),
    );
  }
}