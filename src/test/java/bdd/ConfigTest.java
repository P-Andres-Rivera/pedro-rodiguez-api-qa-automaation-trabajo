package bdd;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.assertEquals;

public class ConfigTest {
    @Test
    void testParallel() {
        // Leer tags desde propiedad del sistema (pasada por Maven)
        String tags = System.getProperty("karate.options", "");

        Results results;
        if (tags != null && !tags.isEmpty()) {
            results = Runner.path("classpath:bdd")
                    .tags(tags)
                    .outputCucumberJson(true)
                    .parallel(5);
        } else {
            results = Runner.path("classpath:bdd")
                    .outputCucumberJson(true)
                    .parallel(5);
        }

        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
}