# COVID-19 in Poland – Shiny App

Shiny App with multiple plotting options which make it easy to analyze the course of the COVID-19 pandemic in Poland

## General idea

COVID-19 pandemic has changed the world we live in. Typical daily activities, which many of us have perceived as obvious, were restricted. Apocalyptyc news about the pandemic were coming from every source of information, encircling people with fear and phobias. Amid this wave of opinions, statistics, charts it was really hard not to get confused. Many of the news contained misleading information. Charts, available on main news websites, which were supposed to show the course of the pandemic, were really often presenting numbers, which for receivers without statistical knowledge seemed to be frightening. This revealed a modern world problem regarding how easy it is to manipulate data. 

This application is dedicated to present only basic statistics. It allows to visualize the number of coronavirus diagnosed cases in multiple ways. The numbers, however, are in absolute values. They are not meaningful by themselves. The data come from Polish government page. The huge limitation is that the government does not provide, at regular basis, information about the number of people tested. They do it only sometimes. At the beginning of June 2020, when this text is written, the voivodeship most hit by coronavirus is Silesia – at least when we look at raw numbers. It can be understood with an example of two, seemingly similar, statements (the example is not based on real-life data):

a) The number of diagnosed cases of coronavirus on day X in Silesia = 500, in Mazovian = 200
b) The number of diagnosed cases of coronavirus on day X in Silesia = 500 and 1000 tests (assumption: 1 test per person) were done, in Mazovian = 200 cases diagnosed and 300 tests conducted

There is the huge difference between these two sentences. The first clearly indicates that it is Silesia which suffers more. However, without the number of tests conducted, this statistic is, actually, useless. Let's look at the example b, if we analyze the number of diagnosed cases in relation to the number of tests, we get a completely different view. In the example, 50 % (500/1000) of Silesian who were tested obtained positive coronavirus result. In the same time, 67 % (200/300) Mazovians tested, got a positive outcome. There are obviously many more statistical aspects, which should be analyzed to reliably state, which region is in fact the most affected. However, with this simple example discussed, it can be seen how easy it is to lie on data by presenting only part of the information available. 

## Data
Database is updated automatically everyday. We base on api provided by vaclavrut on apify - https://apify.com/vaclavrut/covid-pl. This api downloads data from official Polish government site, https://www.gov.pl/.

## Built With

The technologies used to create the aplication:

1. R programming language 
2. Shiny (R library) - all the web interface, interactions with user are handled by Shiny 
3. HTML and CSS - utilized to customise the layout of the application
4. Ggplot (R library) - to produce plots available in the application


## Authors

* **Grzegorz Krochmal** - [GIKroch](https://github.com/GIKroch)
* **Katarzyna Kryńska** - [kasiakry](https://github.com/kasiakry)

See also the list of [contributors](https://github.com/your/project/contributors) who participated in this project.

## License

This project is licensed under the MIT License


