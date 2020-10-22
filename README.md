<img src="https://mir-cdn.behance.net/v1/rendition/project_modules/max_1200/c5689870089735.5f904e31486b2.png" width=300px>

#

Foreplot is the 100% open source decision making platform using multi-criteria decision analysis (MCDA) methods. Foreplot can help you in ranking, prioritizing or choosing from among alternatives. It will help you structure multiple criteria or attributes into a hierarchy of decision criteria. 

Foreplot currently implements 3 comparison methods:

- Analytic Hierachy Process (AHP) <a href="https://en.wikipedia.org/wiki/Analytic_hierarchy_process">Wikipedia article on AHP</a>
- Multi-attribute global inference of quality (MAGIQ) <a href="https://en.wikipedia.org/wiki/Multi-attribute_global_inference_of_quality">Wikipedia article on MAGIQ</a>
- Direct / SMART method


## Demo site

Demo site is hosted on Heroku: 

<a href="https://foreplot.herokuapp.com/">https://foreplot.herokuapp.com/</a>

You can browse without logging in, or you can sign up with your email account and start using the application.


## Screenshots

<img src="https://mir-s3-cdn-cf.behance.net/project_modules/max_1200/06286070089735.5b97cf5a79230.png" width=632px>
<img src="https://mir-s3-cdn-cf.behance.net/project_modules/max_1200/21432470089735.5b97cf5a7984b.png" width=632px>
<img src="https://mir-s3-cdn-cf.behance.net/project_modules/max_1200/9f0c8070089735.5b97cf5a7b046.png" width=632px>


## Features

- Comparison methods:
  - AHP
  - MAGIQ
  - SMART
- Analysis:
  - Rank chart & table
  - Visualization of decision hierarchy and weights of priority presented using Sankey diagram
  - Sensitivity analysis to play what-if scenarios


## Built With

Back end:
- [Ruby on Rails](https://github.com/rails/rails) &mdash; This project is a Rails app.
- [PostgreSQL](https://www.postgresql.org/) &mdash; The main data store is in Postgres.

Front end:
- [D3.js](https://d3js.org/) &mdash; Visualization charts.
- [jQuery](https://jquery.com) and [jQuery UI](https://jqueryui.com) &mdash; User interface
- [jqPlot](https://www.jqplot.com/) &mdash; Charting & Plotting for jQuery framework.
- [Twitter Bootstrap](https://getbootstrap.com/) 

And a bunch of Ruby Gems, a complete list of which you can find at [/master/Gemfile](https://github.com/medhiwidjaja/foreplot/blob/master/Gemfile).


## This project v. Foreplot.com (now defunct)

This open source project is a rewrite of the old Foreplot.com website. Although the user-interface is almost the same. The original Foreplot.com used MongoDB as a NoSQL data store, while this project uses PostgreSQL database. This alone requires fundamental change in model design. Only 3 comparison methods are implemented, and proprietary analysis methods are not implemented. 

Currently, this project only does not implement group decision, only single decision maker is supported. 

_Note to old Foreplot.com users:_

If you have old archives of articles, there is no feature to import it since the underlying database and formats are entirely different. You should be able to key in the input data as long as the only for 1 decision maker user, and only using the supported comparison methods.


## Development

- I consider this an alpha version. There are still issues with the current release.
- Planned features include group decision making process, more visualization and analysis methods.


## Contributing

Foreplot is **100% free** and **open source**. I'm hoping that it will attract people to contribute to the development of this project. I 
accepts contribution from the public &ndash; including you!

You can open issues for bugs you've found or features you think are missing. You can also submit pull requests to this repository.


## Copyright / License

Copyright 2019 - 2020  Medhi Widjaja

Copyright 2012 - 2018 Foreplot CV.

This program is free software: you can redistribute it and/or modify it under the terms of the GNU Affero General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License along with this program. If not, see <https://www.gnu.org/licenses/>.


