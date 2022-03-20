import 'package:flutter/material.dart';

class ExtendedGridView<T> extends StatelessWidget {
  final List<T> data;
  final T primary;
  final Widget Function(T data) itemBuilder;
  const ExtendedGridView({
    required this.data,
    required this.primary,
    required this.itemBuilder,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width / 2;
    return Column(
      // mainAxisSize: MainAxisSize.min,
      children: [
        if (data.isNotEmpty)
          SizedBox(
            height: size,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              itemCount: data.length,
              padding: const EdgeInsets.all(5.0),
              itemBuilder: (context, index) => Container(
                padding: const EdgeInsets.all(5.0),
                width: size,
                height: size,
                child: itemBuilder(data[index]),
              ),
            ),
          ),
        Expanded(child: itemBuilder(primary)),
      ],
    );
  }
}
