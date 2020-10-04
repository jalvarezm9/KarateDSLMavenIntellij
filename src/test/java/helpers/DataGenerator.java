package helpers;

import com.github.javafaker.Faker;
import net.minidev.json.JSONObject;

public class DataGenerator {

    public static String getRandomEmail(){
        Faker faker=new Faker();
        String email=faker.name().firstName().toLowerCase() + faker.random().nextInt(0,100) +"@test.com";
        return email;
    }

    public static String getRandomUserName(){
        Faker faker=new Faker();
        String username=faker.name().username();
        return username;
    }

    public static JSONObject getRandomArticleValues(){
        Faker faker=new Faker();
        String title_=faker.gameOfThrones().character();
        String description_=faker.gameOfThrones().city();
        String body_=faker.gameOfThrones().quote();

        JSONObject json = new JSONObject();
        json.put("title",title_);
        json.put("description",description_);
        json.put("body",body_);
        return json;
    }
}
