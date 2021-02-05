import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_wallpaper/bloc/searchImage/searchimage_bloc.dart';
import 'package:flutter_wallpaper/ui/widgets/widgets.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()
      ..addListener(() {
        if (_scrollController.offset ==
                _scrollController.position.maxScrollExtent &&
            context.read<SearchimageBloc>().state.status !=
                ImagesStatus.searchImagePaginating) {
          context.read<SearchimageBloc>().add(ImagesPaginate());
        }
      });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Column(
          children: [
            SearchImgeBox(),
            Expanded(
              child: BlocConsumer<SearchimageBloc, SearchimageState>(
                listener: (context, state) {
                  if (state.status == ImagesStatus.searchImagePaginating) {
                    Scaffold.of(context).hideCurrentSnackBar();
                    Scaffold.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.black,
                        content: Text('Загрузка фотографий'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  } else if (state.status ==
                      ImagesStatus.searchImageNoMorePhotos) {
                    Scaffold.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Фото больше нет'),
                        duration: Duration(milliseconds: 1500),
                      ),
                    );
                  } else if (state.status == ImagesStatus.searchImageError) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text('Ошибка'),
                        content: Text(state.failure.message),
                        actions: [
                          FlatButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text('OK'),
                          ),
                        ],
                      ),
                    );
                  }
                },
                builder: (context, state) {  
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      state.images.isNotEmpty
                      ? ImageList(images: state.images,controller: _scrollController)
                      : Center(
                            child: Text('Нет результатов'),
                          ),
                      if (state.status == ImagesStatus.searchImageLoading)
                        loading()

                    ],
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
