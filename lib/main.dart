import 'package:flutter/material.dart';

void main() => runApp(new TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'TODO App',
      home: new TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  @override
  createState() => new TodoListState();
}

class TodoListState extends State<TodoList> {
  List<String> _todoItems = [];

//  // This will be called each time the + button is pressed
//  void _addTodoItem() {
//      // Putting our code inside "setState" tells the app that our state has changed, and
//      // it will automatically re-render the list
//      setState(() {
//          int index = _todoItems.length;
//          _todoItems.add('Item ' + index.toString());
//      });
//  }
  void _addTodoItem(String task) {
    //Only add the task if the user actually entered something
    if (task.length > 0) _todoItems.add(task);
  }

  //Build the whole list of todo items
  Widget _buildTodoList() {
    if (_todoItems.length > 0) {
      return new ListView.builder(
        itemBuilder: (context, index) {
          // itemBuilder will be automatically be called as many times as it takes for the
          // list to fill up its available space, which is most likely more than the
          // number of todo items we have. So, we need to check the index is OK.

          if (index < _todoItems.length)
            return _buildTodoItem(_todoItems[index], index);
        },
      );
    } else {
      return new Center(
          child: new Container(
              child: new Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new Image(image: new AssetImage('data_repo/img/chanchito.png')),
          new Center(
            child: new Text(
              'There is not data to show',
              style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
          )
        ],
      )));
    }
  }

  Widget _buildTodoItem(String todoText, int index) {
    return new Container(
      child: new ListTile(
          title: new Text(todoText), onTap: () => _promptRemoveTodoItem(index)),
      decoration: new BoxDecoration(
          border:
              new Border(bottom: new BorderSide(color: new Color(0xFFCCCCCC)))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text('TODO List')),
      body: _buildTodoList(),
      floatingActionButton: new FloatingActionButton(
        //onPressed: _addTodoItem,
        onPressed: _pushAddTodoScreen,
        //pressing the button now open the new screen
        tooltip: "Add task",
        child: new Icon(Icons.add),
      ),
    );
  }

  void _pushAddTodoScreen() {
    //Push this page onto the stack
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      // MaterialPageRoute will automatically animate the screen entry, as well
      // as adding a back button to close it
      return new Scaffold(
        appBar: new AppBar(title: new Text('Add a new Task')),
        body: new TextField(
          autofocus: true,
          onSubmitted: (val) {
            _addTodoItem(val);
            Navigator.pop(context); //Close the add todo screen
          },
          decoration: new InputDecoration(
              hintText: 'Enter something to do...',
              contentPadding: const EdgeInsets.all(16.0)),
        ),
      );
    }));
  }

  // Much like _addTodoItem, this modifies the array of todo strings and
  // notifies the app that the state has changed by using setState
  void _removeTodoItem(int index) {
    setState(() => _todoItems.removeAt(index));
  }

  // Show an alert dialog asking the user to confirm that the task is done
  void _promptRemoveTodoItem(int index) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: new Text('Mark "${_todoItems[index]}" as done?'),
              actions: <Widget>[
                new FlatButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: new Text('CANCEL')),
                new FlatButton(
                  onPressed: () {
                    _removeTodoItem(index);
                    Navigator.of(context).pop();
                  },
                  child: new Text('MARK AS DONE'),
//                  color: Colors.lightBlue,
//                  textColor: new Color(0xFFFFFFFF),
                ),
              ]);
        });
  }
}
