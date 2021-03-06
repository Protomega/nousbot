    /*
    * weather.js, written by joshmanders
    * adapted by eggsby
    * and modified more by Protomega
    * pulls out xml data from google apis
    */
     
    module.exports = function(app) {
      var command, xml, parse, weather;
      command = app.util.command;
      parse = app.util.parse;
      xml = app.util.xml;
      weather = function(nous) {
        return command(nous, "weather", function(input) {
            if(input.msg == "russia"){
                return nous.say(input.to, "In Russia, you don't find weather! Weather find you!");
            } else {
                var url, urisafe;
                if(input.msg == "you"){
                    urisafe = encodeURIComponent("moscow");
                } else {
                    urisafe = encodeURIComponent(input.msg);
                }
                url = "http://www.google.com/ig/api?weather=" + urisafe;
                return parse(url, function(err, $, data) {
                  var results = {}, city, conditions, grab;
                  grab = ["condition", "temp_f", "temp_c", "humidity", "wind_condition"];
                  conditions = xml(data);
                  city = conditions.weather.forecast_information.city["@"]["data"]
                  for (var i = 0, len = grab.length; i < len; i++) {
                    results[grab[i]] = conditions.weather.current_conditions[grab[i]]["@"]["data"]
                  }
                  console.log(results);
                  if(results.condition) {
                    var response;
                    if(input.msg == "you"){
                        city = "You";
                    }
                    response = input.from + ": " +
                               city + ": " +
                               results.condition + ", " +
                               results.temp_f + "F/" +
                               results.temp_c + "C " +
                               results.humidity + ", " +
                               results.wind_condition;
                    return nous.say(input.to, response);
                  } else {
                    return nous.say('Sorry we couldn\'t find any weather info for ' + input.msg);
                  }
                });
            }
        });
      };
      return {
        start: weather
      };
    };
