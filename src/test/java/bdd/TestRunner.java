package bdd;

import com.intuit.karate.junit5.Karate;
import org.junit.jupiter.api.DisplayName;

@DisplayName("Karate Test Suite")
public class TestRunner {

    @Karate.Test
    @DisplayName("Login Tests")
    Karate testLogin() {
        return Karate.run("loginAuth").relativeTo(getClass());
    }

    @Karate.Test
    @DisplayName("Register Tests")
    Karate testRegister() {
        return Karate.run("registerAuth").relativeTo(getClass());
    }

    @Karate.Test
    @DisplayName("Product Tests")
    Karate testProducto() {
        return Karate.run("newProducto").relativeTo(getClass());
    }
}