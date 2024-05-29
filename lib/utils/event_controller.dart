import 'dart:async';

class EventController {
  StreamController _streamController = StreamController.broadcast();

  Stream get stream {
    if (_streamController.isClosed) {
      _streamController = StreamController.broadcast();
    }
    return _streamController.stream;
  }

  void addEvent(event) {
    if (_streamController.isClosed) {
      _streamController = StreamController.broadcast();
    }
    _streamController.add(event);
  }

  void dispose() {
    _streamController.close();
  }
}

EventController eventController = EventController();
