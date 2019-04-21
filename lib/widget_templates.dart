import 'package:flutter/material.dart';

Widget buildFutureBuilder<T>(
  BuildContext ctx, {
  @required Future future,
  @required AsyncWidgetBuilder<T> builder,
  Widget loading,
  Widget error,
}) =>
    FutureBuilder<T>(
        future: future,
        builder: (BuildContext ctx, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.none:
            case ConnectionState.active:
            case ConnectionState.waiting:
              return loading ?? buildLoadingNotification(ctx);
              break;
            case ConnectionState.done:
              if (snapshot.hasError)
                return error ??
                    buildErrorNotification(
                        ctx, "${snapshot.error}" ?? "Unknown");
              return builder(ctx, snapshot);
          }
        });

Widget _buildNotification(BuildContext ctx, String text, Widget widget) =>
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          widget,
          Container(height: 20),
          Text(
            text,
            style: Theme.of(ctx).textTheme.title,
          )
        ],
      ),
    );

Widget _buildIconNotification(
  BuildContext ctx,
  String text, [
  IconData icon,
]) =>
    _buildNotification(
      ctx,
      text,
      FittedBox(
        fit: BoxFit.scaleDown,
        child: Icon(icon, size: 140),
      ),
    );

Widget buildLoadingNotification(BuildContext ctx) => _buildNotification(
      ctx,
      "Загрузка",
      CircularProgressIndicator(),
    );

Widget buildErrorNotification(BuildContext ctx, String error) =>
    _buildIconNotification(ctx, error, Icons.error);
