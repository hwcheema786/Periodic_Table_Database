#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only --no-align -c"

if [[ -z $1 ]]
then
  echo Please provide an element as an argument.
  exit
fi

ELEMENT=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE atomic_number::text = '$1' OR symbol = '$1' OR name = '$1'")
if [[ -z $ELEMENT ]]
then
  echo I could not find that element in the database.
else
  ATOMIC_NUMBER=$(echo "$ELEMENT" | cut -d '|' -f 1 | xargs)
  SYMBOL=$($PSQL "SELECT symbol FROM elements FULL JOIN properties USING(atomic_number) WHERE atomic_number=$ATOMIC_NUMBER")
  NAME=$($PSQL "SELECT name FROM elements FULL JOIN properties USING(atomic_number) WHERE atomic_number=$ATOMIC_NUMBER")
  ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM elements FULL JOIN properties USING(atomic_number) WHERE atomic_number=$ATOMIC_NUMBER")
  MELT=$($PSQL "SELECT melting_point_celsius FROM elements FULL JOIN properties USING(atomic_number) WHERE atomic_number=$ATOMIC_NUMBER")
  BOIL=$($PSQL "SELECT boiling_point_celsius FROM elements FULL JOIN properties USING(atomic_number) WHERE atomic_number=$ATOMIC_NUMBER")
  TYPE=$($PSQL "SELECT type FROM types FULL JOIN properties USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
  echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
fi