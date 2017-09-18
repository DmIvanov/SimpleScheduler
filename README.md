Sample project

The project is made under XCode 9 GM (Version 9.0 (9A235))

Here is a simple app where user can create, edit and remove shedulers. Created ones are stored in file system and loaded after relaunching the app.

Parts of the app:
- MainInteractor.
	* general business logic inside the app
	* switching between different scenes
	* processing app events from the AppDelegate 
	* storing instances of global objects like DataSourse, NetworkManager, BackgroundServices, UserSession... 
	There's not so much of it so far =).
- DataSource.
	* The global storage over the entire app
	* Persistence
- ViewControllerFactory.
	* Instantiating app scenes/viewControllers
- Scenes (Schedule, Overview): ViewControllers + DataModels.
	* VCs are only responsible for the layout, catching user interactions, displaying data from the models.
	* all the business logic, data formatting and processing, interacting with the DataSource is suppose to be located in the models, not VCs.

Some used approaches:
- Modularity. Each piece of functionality is incapsulated in a proper class (set of classes).
- Clear objects' responsibilities (Not everywhere it's one responsibility, but not more than couple of them)
- Dependency Injection. Most of the objects are instantiated using DI and could be easily tested (with a help of moch-objects)

TODO:
- Additional functionality
    * Schedulers themselves
- UnitTests
