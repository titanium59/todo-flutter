enum TodoPriority{low , medium , high}

class MyTodo{
  int id;
  String name;
  TodoPriority priority;
  bool completed;

  MyTodo({
    required this.id,
    required this.name,
    required this.priority,
    this.completed = false
  });

  static List<MyTodo> todos = [];

}

