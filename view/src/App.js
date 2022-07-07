import { useQuery, gql } from '@apollo/client';

const GET_SUBMISSIONS = gql`
  query ListSubmissions {
    region(order_by: {order_by: asc}, where: {submissions: {id: {_gte: "0"}}}) {
      code
      label_en
      label_de
      order_by
      submissions(order_by: {order_by: asc}) {
        id
        label_en
        label_de
        date
        order_by
      }
    }
  }
`;

function DisplaySubmissions() {
  const { loading, error, data } = useQuery(GET_SUBMISSIONS);

  if (loading) return <p>Loading...</p>;
  if (error) return <p>Error :(</p>;

  return data.region.map(({ code, label_en, label_de, submissions }) => (
    <ul>
      <li key={code}>{label_en} ({label_de})</li>
      <ul>
      {
        submissions.map(({id, label_en}) => (
          <li key={id.toString()}>{label_en}</li>
        ))
      }
      </ul>
    </ul>
  ));
}

export default function App() {
  return (
    <div>
      <h2>NEXTgen ZSE</h2>
      <DisplaySubmissions />
    </div>
  );
}