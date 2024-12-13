package conduitApp.performance.createTokens;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

import com.intuit.karate.Runner;

public class CreateTokens {

    private static final ArrayList<String> tokens = new ArrayList<>();
    private static final AtomicInteger counter = new AtomicInteger();

    private static String[] emails = {
        "karatetester12suresh@test.com",
        "karatetester122suresh@test.com",
        "karatetester1222suresh@test.com"
    };

    public static String getNextToken(){
        return tokens.get(counter.getAndIncrement() % tokens.size());
    }


    public static void createAccessTokens(){

        for(String email: emails){
            Map<String, Object> account = new HashMap<>();
            account.put("userEmail", email);
            account.put("userPassword", "welcome1234");
            Map<String, Object> result = Runner.runFeature("classpath:helpers/CreateToken.feature", account, true);
            tokens.add(result.get("authToken").toString());
        }

    }
    
}