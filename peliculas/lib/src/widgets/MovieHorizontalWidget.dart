import 'package:flutter/material.dart';
import 'package:peliculas/src/models/PeliculaModel.dart';

class MovieHorizontalWidget extends StatelessWidget {
  MovieHorizontalWidget(
      {@required this.peliculas, @required this.siguientePagina});

  final List<Pelicula> peliculas;
  final Function siguientePagina;

  final _pageController =
      new PageController(initialPage: 1, viewportFraction: 0.3);

  List<Widget> _tarjetas(BuildContext context) {
    return peliculas.map((pelicula) {
      return Container(
        margin: EdgeInsets.only(right: 15.0),
        child: Column(children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
                image: NetworkImage(pelicula.getPosterImg()),
                placeholder: AssetImage('assets/img/no-image.jpg'),
                fit: BoxFit.cover,
                height: 160.0),
          ),
          SizedBox(height: 5.0),
          Text(
            pelicula.title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )
        ]),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final _screenSize = MediaQuery.of(context).size;
    _pageController.addListener(() {
      if (_pageController.position.pixels >=
          _pageController.position.maxScrollExtent - 200) {
        siguientePagina();
      }
    });

    return Container(
      height: _screenSize.height * 0.2,
      child: PageView(
        children: _tarjetas(context),
        pageSnapping: false,
        controller: _pageController,
      ),
    );
  }
}
