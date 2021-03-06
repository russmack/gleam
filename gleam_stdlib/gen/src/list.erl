-module(list).
-compile(no_auto_import).

-export([length/1, reverse/1, is_empty/1, contains/2, head/1, tail/1, filter/2, map/2, traverse/2, drop/2, take/2, new/0, append/2, flatten/1, fold/3, fold_right/3, find/2]).

length(A) ->
    erlang:length(A).

reverse(A) ->
    lists:reverse(A).

is_empty(List) ->
    List =:= [].

contains(List, Elem) ->
    case List of
        [] ->
            false;

        [Head | Rest] ->
            Head =:= Elem orelse contains(Rest, Elem)
    end.

head(List) ->
    case List of
        [] ->
            {error, empty};

        [X | _] ->
            {ok, X}
    end.

tail(List) ->
    case List of
        [] ->
            {error, empty};

        [_ | Xs] ->
            {ok, Xs}
    end.

do_filter(List, Fun, Acc) ->
    case List of
        [] ->
            reverse(Acc);

        [X | Xs] ->
            NewAcc = case Fun(X) of
                true ->
                    [X | Acc];

                false ->
                    Acc
            end,
            do_filter(Xs, Fun, NewAcc)
    end.

filter(List, Fun) ->
    do_filter(List, Fun, []).

do_map(List, Fun, Acc) ->
    case List of
        [] ->
            reverse(Acc);

        [X | Xs] ->
            do_map(Xs, Fun, [Fun(X) | Acc])
    end.

map(List, Fun) ->
    do_map(List, Fun, []).

do_traverse(List, Fun, Acc) ->
    case List of
        [] ->
            {ok, reverse(Acc)};

        [X | Xs] ->
            case Fun(X) of
                {ok, Y} ->
                    do_traverse(Xs, Fun, [Y | Acc]);

                {error, Error} ->
                    {error, Error}
            end
    end.

traverse(List, Fun) ->
    do_traverse(List, Fun, []).

drop(List, N) ->
    case N =< 0 of
        true ->
            List;

        false ->
            case List of
                [] ->
                    [];

                [_ | Xs] ->
                    drop(Xs, N - 1)
            end
    end.

do_take(List, N, Acc) ->
    case N =< 0 of
        true ->
            reverse(Acc);

        false ->
            case List of
                [] ->
                    reverse(Acc);

                [X | Xs] ->
                    do_take(Xs, N - 1, [X | Acc])
            end
    end.

take(List, N) ->
    do_take(List, N, []).

new() ->
    [].

append(A, B) ->
    lists:append(A, B).

do_flatten(Lists, Acc) ->
    case Lists of
        [] ->
            Acc;

        [L | Rest] ->
            do_flatten(Rest, append(Acc, L))
    end.

flatten(Lists) ->
    do_flatten(Lists, []).

fold(List, Acc, Fun) ->
    case List of
        [] ->
            Acc;

        [X | Rest] ->
            fold(Rest, Fun(X, Acc), Fun)
    end.

fold_right(List, Acc, Fun) ->
    case List of
        [] ->
            Acc;

        [X | Rest] ->
            Fun(X, fold_right(Rest, Acc, Fun))
    end.

find(Haystack, F) ->
    case Haystack of
        [] ->
            {error, not_found};

        [X | Rest] ->
            case F(X) of
                {ok, X1} ->
                    {ok, X1};

                _ ->
                    find(Rest, F)
            end
    end.
