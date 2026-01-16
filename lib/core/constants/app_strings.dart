/// Centralized string constants
/// Use everywhere instead of hardcoded text
class AppStrings {
  // --------------------------------------------------
  // App
  // --------------------------------------------------
  static const String appName = 'Todo';
  static const String appTagline = 'Organize your tasks effortlessly';

  // --------------------------------------------------
  // Navigation / Titles
  // --------------------------------------------------
  static const String myTasks = 'My Tasks';
  static const String categories = 'Categories';
  static const String tasks = 'Tasks';
  static const String task = 'Task';
  static const String taskDetails = 'Task Details';
  static const String settings = 'Settings';

  static const String searchTasks = 'Search tasks';
  static const String searchAllTasks = 'Search all tasks...';
  static const String searchCategories = 'Search categories';

  // --------------------------------------------------
  // Buttons / Actions
  // --------------------------------------------------
  static const String create = 'Create';
  static const String save = 'Save';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';
  static const String rename = 'Rename';
  static const String edit = 'Edit';
  static const String view = 'View';
  static const String done = 'Done';
  static const String confirm = 'Confirm';
  static const String tryAgain = 'Try Again';

  static const String addTask = 'Add Task';
  static const String createTask = 'Create Task';
  static const String editTask = 'Edit Task';
  static const String saveTask = 'Save Task';

  /// Used in Create/Edit task modals
  static const String continueText = 'Continue';

  static const String createCategory = 'Create Category';
  static const String editCategory = 'Edit Category';
  static const String addCategory = 'Add Category';
  static const String saveChanges = 'Save Changes';
  static const String icon = 'Icon';

  // --------------------------------------------------
  // Task Fields
  // --------------------------------------------------
  static const String taskTitle = 'Task Title';
  static const String taskTitleHint = 'Enter task title...';

  static const String taskDescription = 'Task Description';
  static const String taskDescriptionHint = 'Add more details...';

  static const String description = 'Description';

  static const String createTaskDescription =
      'Add details like deadline, priority, and attachments.';

  static const String dueDate = 'Due date';
  static const String dueTime = 'Due time';
  static const String selectDeadline = 'Select Deadline';

  // --------------------------------------------------
  // Status / Priority
  // --------------------------------------------------
  static const String priority = 'Priority';
  static const String important = 'Important';

  static const String completed = 'Completed';
  static const String pending = 'Pending';

  static const String markCompleted = 'Mark as completed';
  static const String markIncomplete = 'Mark as incomplete';
  static const String markAsImportant = 'Mark as priority';

  // --------------------------------------------------
  // Category
  // --------------------------------------------------
  static const String category = 'Category';
  static const String categoryName = 'Category name';
  static const String selectCategory = 'Select category';
  static const String renameCategory = 'Rename category';
  static const String deleteCategory = 'Delete category';

  // --------------------------------------------------
  // Time / Labels
  // --------------------------------------------------
  static const String overdue = 'Overdue';
  static const String today = 'Today';
  static const String tomorrow = 'Tomorrow';
  static const String noDeadline = 'No deadline';

  // --------------------------------------------------
  // Attachments
  // --------------------------------------------------
  static const String attachments = 'Attachments';
  static const String addAttachment = 'Add a link or attachment';

  static const String links = 'Links';
  static const String images = 'Images';
  static const String documents = 'Documents';

  static const String addLink = 'Add link';
  static const String addImage = 'Add image';
  static const String addDocument = 'Add document';

  // --------------------------------------------------
  // Empty States
  // --------------------------------------------------
  static const String noTasksTitle = 'No Tasks Yet';
  static const String noTasksSubtitle =
      'Create your first task to start organizing your day.';

  static const String noCategoriesTitle = 'No Categories';
  static const String noCategoriesSubtitle =
      'Create a category to organize your tasks better.';

  static const String noSearchResultsTitle = 'No Results Found';
  static const String noSearchResultsSubtitle =
      'Try searching with a different keyword.';

  // --------------------------------------------------
  // Dialogs / Confirmations
  // --------------------------------------------------
  static const String deleteTaskTitle = 'Delete Task?';
  static const String deleteTaskMessage =
      'This task will be permanently deleted.';

  static const String deleteCategoryTitle = 'Delete Category?';
  static const String deleteCategoryMessage =
      'All tasks under this category will be removed.';

  // --------------------------------------------------
  // Errors / Validation
  // --------------------------------------------------
  static const String requiredField = 'This field is required';
  static const String invalidDate = 'Invalid date selected';
  static const String somethingWentWrong =
      'Something went wrong. Please try again.';
}
