// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract Todos {
    // define a struct called 'Todo'
    struct Todo {
        string text;
        bool completed;
    }

    // array of 'Todo' structs
    Todo[] public todos;

    function create(string calldata _text) public {
        // 3 ways to create a new todo:
        // (1) direct initialization
        todos.push(Todo(_text, false));
        // (2) named arguments
        todos.push(Todo({text: _text, completed: false}));
        // (3) create an empty struct in memory, then set values
        Todo memory todo;
        todo.text = _text;
        // 'completed' defaults to false

        todos.push(todo);
    }

    function get(uint256 _index) public view returns (string memory text, bool completed) {
        Todo storage todo = todos[_index];
        return (todo.text, todo.completed);
    }

    function updateText(uint256 _index, string calldata _text) public {
        Todo storage todo = todos[_index];
        todo.text = _text;
    }

    function toggleCompleted(uint256 _index) public {
        Todo storage todo = todos[_index];
        todo.completed = !todo.completed;
    }
}
