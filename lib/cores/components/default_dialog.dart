import 'package:auto_size_text/auto_size_text.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class DefaultDialog extends StatefulWidget {
  final String? title;
  final String? msg;
  final int status;
  final Function() onPressed;
  final bool outsideDismiss;
  final bool canPop;

  const DefaultDialog(this.title, this.msg, this.status, this.onPressed,
      this.outsideDismiss, this.canPop, {super.key});
  @override
  _DefaultDialogState createState() => _DefaultDialogState();
}

class _DefaultDialogState extends State<DefaultDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _scaleAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.elasticInOut);

    _controller.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.canPop,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            GestureDetector(
              onTap: widget.outsideDismiss
                  ? () => Navigator.of(context).pop()
                  : null,
              child: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.black.withOpacity(0.3),
              ),
            ),
            ScaleTransition(
              scale: _scaleAnimation,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.65,
                height: MediaQuery.of(context).size.height * 0.45,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: double.infinity,
                      height: 150.0,
                      child: FlareActor(
                        'assets/images/${widget.status == 1 ? 'success' : 'error'}.flr',
                        alignment: Alignment.center,
                        fit: BoxFit.cover,
                        animation: widget.status == 1 ? 'Success' : 'Error',
                      ),
                    ),
                    AutoSizeText(
                      widget.title ?? 'Response !',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.none,
                      ),
                      maxLines: 2,
                    ),
                    Expanded(
                      child: AutoSizeText(
                        widget.msg ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black87,
                          fontSize: 14.0,
                          fontWeight: FontWeight.normal,
                          decoration: TextDecoration.none,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Flexible(
                      child: ElevatedButton(
                        style: ButtonStyle(
                          shape: MaterialStateProperty.all(const StadiumBorder()),
                          backgroundColor: MaterialStateProperty.all(Colors.green),
                        ),
                        onPressed: widget.onPressed,
                        child: const Text(
                          'OK',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
