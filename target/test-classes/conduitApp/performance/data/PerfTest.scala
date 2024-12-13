package performance

import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._
import scala.concurrent.duration._
import conduitApp.performance.createTokens.CreateTokens

class PerfTest extends Simulation {
CreateTokens.createAccessTokens()
  val protocol = karateProtocol(
    "api/articles/{articleId}" -> Nil
  )

  protocol.nameResolver = (req, ctx) => req.getHeader("karate-name")
 // protocol.runner.karateEnv("perf")
val csvFeeder = csv("conduitApp/performance/data/articles.csv").circular()
val tokenFeeder = Iterator.continually {Map("token" -> CreateTokens.getNextToken())}
val createArticles = scenario("create and delete articles").feed(csvFeeder).feed(tokenFeeder).exec(karateFeature("classpath:conduitApp/performance/createArticles.feature"))
 

  setUp(
    createArticles.inject(
      atOnceUsers(1),
      nothingFor(4),      
      //rampUsers(3).during(5), 
       constantUsersPerSec(1).during(10)
      // constantUsersPerSec(2).during(10).randomized, 
      // rampUsersPerSec(2).to(10).during(20.seconds),
      // nothingFor(5),
      // constantUsersPerSec(2).during(5)    
      ).protocols(protocol),
    
  )

}