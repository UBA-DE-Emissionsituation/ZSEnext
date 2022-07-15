import { loader } from 'graphql.macro';
import { useQuery } from '@apollo/client';
import React from 'react';

class Region extends React.Component {
  render () {
    return (
      <li>{this.props.name} ({this.props.extra_info}) with {this.props.submissions.length} Submission(s)
        <ul>
        {
          this.props.submissions.map(({id, label_en, date}) => (
            <Submission key={id} name={label_en} date={date} />
          ))
        }
        </ul>
      </li>
    )
  }
}

class Submission extends React.Component {
  render () {
    return <li>{this.props.name} from {new Date(this.props.date).toLocaleDateString()}</li>
  }
}

export default function NavigationTree() {
  const { loading, error, data } = useQuery(loader('../graphql/queries/navigationTree.graphql'));

  if (loading) return <p>Loading...</p>;
  if (error) return <p>Error :(</p>;

  return (
    <ul>
    {
      data.region.map(({ code, label_en, parent, submissions }) => (
        <Region key={code} name={label_en} extra_info={parent.label_en} submissions={submissions} />
      ))
    }
    </ul>
  )
}
