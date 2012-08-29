package com.leandog.gametel.driver.commands;

import static org.hamcrest.CoreMatchers.*;
import static org.junit.Assert.assertThat;

import org.junit.Test;
import org.junit.experimental.theories.*;
import org.junit.runner.RunWith;

import com.leandog.gametel.driver.commands.Command.Target;

@RunWith(Theories.class)
public class CommandTest {

    @Test
    public void itSetsTheAppropriateDefaultsForTheCommand() {
        final Command theCommand = new Command();
        assertThat(theCommand.getName(), is(nullValue()));
        assertThat(theCommand.getArguments(), is(new Object[0]));
    }

    @Test
    public void itConsidersTheNameInTheHash() {
        final Command firstCommand = new Command("command");
        final Command sameCommand = new Command("command");
        assertThat(firstCommand.hashCode(), is(sameCommand.hashCode()));
    }

    @Test
    public void itConsidersTheArgumentsInTheHash() {
        final Command firstCommand = new Command("command", 1, "hello");
        final Command sameCommand = new Command("command", 1, "hello");
        assertThat(firstCommand.hashCode(), is(sameCommand.hashCode()));
    }

    @Test
    public void itConsidersVoidMethodsOfTheSameNameAsEqual() {
        assertThat(new Command("command"), is(new Command("command")));
    }

    @Test
    public void itConsidersMethodsWithDifferentNamesNotEqual() {
        assertThat(new Command("command"), is(not(new Command("the other command"))));
    }

    @Test
    public void aNullCommandCannotEqualAValidCommand() {
        assertThat(new Command("command").equals(null), is(false));
    }

    @Test
    public void itConsidersTheArgumentsWhenDeterminingEquality() {
        assertThat(new Command("command", 1, "hello"), is(new Command("command", 1, "hello")));
    }

    @DataPoints
    public static Command[] defaultTargets() {
        return new Command[] {
            new Command(),
            new Command("name"),
            new Command("name", 1)
        };
    }
    
    @Theory
    public void itDefaultsTheTargetToLastResultOrRobotium(final Command command) {
        assertThat(command.getTarget(), is(Target.LastResultOrRobotium));
    }
    
}
