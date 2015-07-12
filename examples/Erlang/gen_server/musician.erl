% Autogenerated with DRAKON Editor 1.26

-module(musician).
-export([code_change/3, handle_call/3, handle_cast/2, handle_info/2, init/1, run/0, start_link/2, stop/1, terminate/2]).
-behaviour(gen_server).

-record(state, {name="", role, skill=good}).
-define(DELAY, 750).

code_change(_OldVsn, State, _Extra) ->
    % item 75
    {ok, State}
.

first_names() ->
    % item 11
    ["Valerie", "Arnold", "Carlos", "Dorothy", "Keesha",
        "Phoebe", "Ralphie", "Tim", "Wanda", "Janet"]
.

handle_call(Message, _From, State) ->
    % item 38
    case Message =:= stop of true -> 
        % item 41
        {stop, normal, ok, State}
    ; false ->
        % item 43
        {noreply, State, ?DELAY}
    end
.

handle_cast(_Message, State) ->
    % item 49
    {noreply, State, ?DELAY}
.

handle_info(timeout, State) ->
    % item 55
    #state {
    	name = Name,
    	skill = Skill
    } = State,
    case Skill of
        good ->
            % item 62
            io:format("~s produced sound!~n",[Name]),
            % item 68
            {noreply, State, ?DELAY}
        ;
        bad ->
            % item 63
            case random:uniform(5) =:= 1 of true -> 
                % item 66
                io:format(
                  "~s played a false note. Uh oh~n",
                  [Name]
                ),
                % item 69
                {stop, bad_note, State}
            ; false ->
                % item 62
                io:format("~s produced sound!~n",[Name]),
                % item 68
                {noreply, State, ?DELAY}
            end
        ;
        _ ->
        throw("Unexpected switch value")
    end
.

init([Role, Skill]) ->
    % item 96
    process_flag(trap_exit, true),
    % item 6
    random:seed(now()),
    % item 29
    TimeToPlay = random:uniform(3000),
    Name = pick_name(),
    % item 30
    io:format(
      "Musician ~s, playing the ~s entered the room~n",
      [Name, Role]
    ),
    % item 31
    State = #state {
    	name = Name,
    	role = Role,
    	skill = Skill
    },
    % item 32
    {ok, State, TimeToPlay}
.

last_names() ->
    % item 16
    ["Frizzle", "Perlstein", "Ramon", "Ann", "Franklin",
        "Terese", "Tennelli", "Jamal", "Li", "Perlstein"]
.

pick_name() ->
    % item 21
    First = random_element(first_names()),
    Last = random_element(last_names()),
    % item 42
    First ++ " " ++ Last
.

random_element(List) ->
    % item 27
    Length = length(List),
    Index = random:uniform(Length),
    % item 28
    lists:nth(Index, List)
.

run() ->
    % item 114
    start_link(bass, bad),
    % item 116
    start_link(cello, good),
    % item 115
    timer:sleep(10000),
    % item 117
    stop(cello)
.

start_link(Role, Skill) ->
    % item 102
    gen_server:start_link(
    	{local, Role},
    	?MODULE,
    	[Role, Skill], 
    	[]
    )
.

stop(Role) ->
    % item 108
    gen_server:call(Role, stop)
.

terminate(Reason, State) ->
    % item 91
    #state {
    	name = Name,
    	role = Role
    } = State,
    case Reason of
        normal ->
            % item 92
            io:format(
             "~s left the room (~s)~n",
             [Name, Role]
            )
        ;
        bad_note ->
            % item 93
            io:format(
             "~s sucks! kicked that member out of the band! (~s)~n",
             [Name, Role]
            )
        ;
        shutdown ->
            % item 94
            io:format(
             "The manager is mad and fired the whole band! "
             ++ "~s just got back to playing in the subway~n",
             [Name]
            )
        ;
       _ ->
            % item 95
            io:format(
             "~s has been kicked out (~s)",
             [Name, Role]
            )
    end
.


