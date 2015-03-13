# Standard Widgets

The following is a list of Widgets that should be displayed on each Production teams dashboard.

To add / update a widget
* Clone the Code Dashboard project from github ( https://github.com/code-computerlove/code-dashboard )
* Amend your team dashboard in the folder [\dashboards\](../dashboards/) e.g. hmv.erb
* Test locally
* Commit and Push
* Changes will be automatically deployed to Heroku


## Dev Cycle Time

### Dashboard markup

Populate the data-id with the name of the event in the CYCLE\_TIME\_CALCULATION\_EVENTS array in [\jobs\cycle_time.rb](../jobs/cycle_time.rb)
(This is also the same name as the document id in MONGO)

```html
    <li class="flips" data-row="1" data-col="1" data-sizex="1" data-sizey="1">
      <div data-id="hmv_cycle_time_dev" data-view="Cycletime" data-title="Dev Cycle Time"></div>
    </li>
```

### How it works

TODO

## Total Cycle Time

### Dashboard markup

```html
    <li class="flips" data-row="1" data-col="1" data-sizex="1" data-sizey="1">
      <div data-id="hmv_cycle_time" data-view="Cycletime" data-title="Total Cycle Time"></div>
    </li>
```

### How it works

TODO

## Weekly Velocity

### Dashboard markup

Populate the data-id with the name of the event in the BOARD array in [\jobs\velocity.rb](../jobs/velocity.rb)

```html
    <li data-row="1" data-col="2" data-sizex="1" data-sizey="1">
      <div data-id="HMV-velocity" data-view="Velocity" data-title="Weekly Velocity"></div>
    </li>
```

### How it works

* Content is displayed using the Velocity widget [widgets\velocity](../widgets/velocity/)
* Velocity Widget displays last value in collection of Velocities
* Collection of Velocities is populated by \jobs\velocity.rb
* Collection is populated from a MONGO database at startup and repopulated on a 6 hourly cycle using the built in Scheduler class

The Mongo Database is populated by a different Heroku Application which runs code from the Code Velocity project (https://github.com/code-computerlove/code-velocity)
The entry point is /lib/velocity.rb
Heroku runs the app daily at midnight but the code will only calculate the previous weeks velocity on a Monday (on other days nothing is computed).

For each Trello board defined in /lib/config.json the job will
* find all Trello tickets that reached a particular list on the board within the last 7 days (the list being measured is defined in config.json and can be different for each board)
* Sum up the complexity points on the Trello tickets (Trello ticket names must follow a standard format as used by the Chrome plugin "Scrum for Trello")
* Retrieve the collection of Velocities from MONGO DB
* Remove the oldest velocity if the maximum weeks to store has been reached (currently 20 weeks are stored)
* Add the current weeks velocity to the collection and update MONGO DB.

Code uses Trello-Pipes to access Trello (Note that there is a code repo called trello-weekly-velocity which was possibly superceeded by Trello Pipes) 

## Average Velocity

### Dashboard markup

Populate the data-id with the name of the event in the BOARD array in [\jobs\velocity.rb](../jobs/velocity.rb)

#### Default - 4 week average

```html
    <li data-row="2" data-col="1" data-sizex="1" data-sizey="1">
      <div data-id="HMV-velocity" data-view="Avgvelocity" data-title="Average Velocity"></div>
    </li>
```

#### Custom weeks

Populate the attribute "data-weeks" with the number of weeks that the average should follow
```html
    <li data-row="2" data-col="2" data-sizex="1" data-sizey="1">
      <div data-id="HMV-velocity" data-view="Avgvelocity" data-title="Average Velocity" data-weeks="8" ></div>
    </li>
```

### How it works

* Content is displayed using the Average Velocity widget [widgets\avgvelocity](../widgets/avgvelocity/)
* Average Velocity Widget displays the average value of the last x entries in the collection of Velocities (where x is defined in the dashboard markup using the data-weeks attribute)
* Collection of Velocities is populated by [\jobs\velocity.rb](../jobs/velocity.rb)
* Collection is populated from a MONGO database at startup and repopulated on a 6 hourly cycle using the built in Scheduler class

See above for how the MONGO DB is populated

## Project Build and Test Status

TODO