import 'package:autojidelna/lang/l10n_global.dart';
import 'package:autojidelna/methods_vars/portable_refresh.dart';
import 'package:flutter/material.dart';

import 'package:material_symbols_icons/symbols.dart';

class ErrorLoadingData extends StatelessWidget {
  const ErrorLoadingData({super.key});

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: portableSoftRefresh,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Symbols.sentiment_sad,
                size: 250,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.025),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * 0.75,
                child: Text(
                  lang.errorsLoadingData,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ),
              SizedBox(height: MediaQuery.sizeOf(context).height * 0.15),
            ],
          ),
        ),
      ),
    );
  }
}
