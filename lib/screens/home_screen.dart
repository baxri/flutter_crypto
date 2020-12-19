import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../blocs/crypto/crypto_bloc.dart';

import '../models/coin_model.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();

  bool _onScrollNotification(ScrollNotification notif, CryptoLoaded state) {

    print(_scrollController.position.extentAfter);

    if (notif is ScrollNotification &&
        _scrollController.position.extentAfter == 0) {
      context.read<CryptoBloc>().add(LoadMoreCoins(coins: state.coins));
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Coins'),
      ),
      body: BlocBuilder<CryptoBloc, CryptoState>(
        builder: (_, state) {
          return Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Theme.of(context).primaryColor,
                  Colors.grey[900],
                ])),
            child: _buildBody(state),
          );
        },
      ),
    );
  }

  _buildBody(CryptoState state) {
    if (state is CryptoLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation(Theme.of(context).accentColor),
        ),
      );
    } else if (state is CryptoLoaded) {
      final List<Coin> coins = state.coins;

      return RefreshIndicator(
        color: Theme.of(context).accentColor,
        onRefresh: () async {
          setState(() {
            context.read<CryptoBloc>().add(RefreshCoins());
          });
        },
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) =>
              _onScrollNotification(notification, state),
          child: ListView.builder(
            controller: _scrollController,
            itemBuilder: (_, index) {
              final Coin coin = coins[index];

              return ListTile(
                leading: Text(
                  '${++index}',
                  style: TextStyle(
                    color: Theme.of(context).accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                title: Text(
                  coin.fullName,
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  coin.name,
                  style: TextStyle(color: Colors.white70),
                ),
                trailing: Text(
                  '\$${coin.price.toStringAsFixed(4)}',
                  style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.w600),
                ),
              );
            },
            itemCount: coins.length,
          ),
        ),
      );
    } else if (state is CryptoError) {
      return Center(
        child: Text(
          'Error loading coins! \nPlease check your connection',
          textAlign: TextAlign.center,
          style:
              TextStyle(color: Theme.of(context).accentColor, fontSize: 18.0),
        ),
      );
    }
  }
}
