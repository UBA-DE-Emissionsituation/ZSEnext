import { loader } from 'graphql.macro';
import { useQuery } from '@apollo/client';

export default function Statistics() {
  const { loading, error, data } = useQuery(loader('../graphql/queries/statistics.graphql'));

  if (loading) return <p>Loading...</p>;
  if (error) return <p>Error :( {error.message}</p>;

  return <p>Database has {data.sectoral_approach_aggregate.aggregate.count} time series,
    holding {data.sectoral_approach_value_aggregate.aggregate.count} value(s).</p>;
}
