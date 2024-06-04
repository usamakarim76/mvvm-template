import 'package:flutter/material.dart';
import 'package:mvvm/data/response/status.dart';
import 'package:mvvm/view/home/widgets/error_widgets.dart';
import 'package:mvvm/view/home/widgets/logout_button_widget.dart';
import 'package:mvvm/view_model/home_view_model.dart';
import 'package:provider/provider.dart';
import '../../configs/components/loading_widget.dart';
import '../../configs/components/network_image_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {

  HomeViewViewModel  homeViewViewModel = HomeViewViewModel();

  @override
  void initState() {
    // TODO: implement initState
    homeViewViewModel.fetchMoviesListApi();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Popular Shows'),
        actions: const [
          LogoutButtonWidget(),
          SizedBox(width: 20,)
        ],
      ),
      body: ChangeNotifierProvider<HomeViewViewModel>(
        create: (BuildContext context) => homeViewViewModel,
        child: Consumer<HomeViewViewModel>(
            builder: (context, value, _){
              switch(value.moviesList.status){
                case Status.loading:
                  return const Center(child: LoadingWidget());
                case Status.error:
                  return const HomeErrorWidget();
                case Status.completed:
                  if(value.moviesList.data!.tvShows == null){
                    return const Center(child: Text('Something went wrong, please try again later'));
                  }
                  if(value.moviesList.data!.tvShows!.isEmpty){
                    return ElevatedButton(onPressed: (){
                      homeViewViewModel.fetchMoviesListApi();
                    }, child: const Text('No data found'));
                  }
                  return ListView.builder(
                      itemCount: value.moviesList.data!.tvShows!.length,
                      itemBuilder: (context,index){
                        final moviesList = value.moviesList.data!.tvShows![index] ;
                        return Card(
                          child: ListTile(
                            leading: NetworkImageWidget(
                              borderRadius: 5,
                              imageUrl: moviesList.imageThumbnailPath.toString(),
                            )  ,
                            title: Text(moviesList.name.toString()),
                            subtitle: Text(moviesList.network.toString()),
                            trailing: Text(moviesList.status.toString()),
                          ),
                        );
                      });
                default:
                  return Container();
              }
            }),
      ) ,
    );
  }
}

