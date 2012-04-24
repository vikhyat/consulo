require_relative 'network_element.rb'

# Operations to be supported:
# - Poll a new OID.
# - List all tracked OIDs.
# - Delete an OID.
# - LDCs:
#   - Add an LDC
#   - Remove an LDC
# - Data query

# Details of tracked OIDs needs to be stored somewhere persistent.
# For now they will be stored in a file, but it would be wise to make this
# something more robust like a Redis store or something.

