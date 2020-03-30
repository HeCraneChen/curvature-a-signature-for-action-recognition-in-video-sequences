#include "assignment3_context.h"
#include <moveit_msgs/RobotTrajectory.h>
#include <moveit/planning_scene/planning_scene.h>
#include <cmath>
#include <cstdlib>


struct Node
{
    CS436Context::vertex data;
    vector<Node *>child;
};

Node *newNode(CS436Context::vertex data)
{
    Node *temp = new Node;
    temp->data = data;
    return temp;
}

// print a vertex
void CS436Context::print( const CS436Context::vertex& q ) const {
  for( int j=0; j<6; j++ ){
    std::cout << std::setw(13) << q[j];
  }
}

// utility function to test for a collision    Check did we sample in the obstacle in RRT
bool CS436Context::is_colliding( const vertex& q ) const {
  moveit::core::RobotState robotstate( robotmodel );
  robotstate.setJointGroupPositions( "manipulator", q );
  if( getPlanningScene()->isStateColliding( robotstate, "manipulator", false ) )
    { return true; }
  else
    { return false; }
}

// utility function to interpolate between two configurations     Check the path
CS436Context::vertex CS436Context::interpolate( const CS436Context::vertex& qA,
						const CS436Context::vertex& qB,
						double t ){
  CS436Context::vertex qt( qA.size(), 0.0 );
  for( std::size_t i=0; i<qt.size(); i++ )
    { qt[i] = ( 1.0 - t )*qA[i] + t*qB[i]; }
  return qt;
}

CS436Context::CS436Context( const robot_model::RobotModelConstPtr& robotmodel,
			    const std::string& name, 
			    const std::string& group, 
			    const ros::NodeHandle& nh ) :
  planning_interface::PlanningContext( name, group ),
  robotmodel( robotmodel ){}

CS436Context::~CS436Context(){}


// TODO
CS436Context::vertex CS436Context::random_sample( const CS436Context::vertex& q_goal ) const {  
  CS436Context::vertex q_rand;

  // TODO return a random sample q_rand with goal bias.
  // Create a random sample. The returned vertex represents a collision-free
  // configuration (i.e. 6 joints) of the robot.
  // return  A collision-free configuration
  double upper_bound = M_PI;
  double lower_bound = - M_PI;

  for (int i = 0 ; i < 6;i++){
        // q_rand[i] = lower_bound + ( rand() % ( upper_bound - lower_bound + 1 ) );
        double deviation = min(upper_bound - q_goal[i], q_goal[i] - lower_bound) / 3;
        q_rand[i] = normal_distribution(q_goal[i], deviation);
  }

  while (CS436Context::is_colliding( q_rand )){
      for (int i = 0 ; i < 6;i++){
          // q_rand[i] = lower_bound + ( rand() % ( upper_bound - lower_bound + 1 ) );
          double deviation = min(upper_bound - q_goal[i], q_goal[i] - lower_bound) / 3;
          q_rand[i] = normal_distribution(q_goal[i], deviation);
      }
  }
  return q_rand;

  }


// TODO
double CS436Context::distance( const CS436Context::vertex& q1, const CS436Context::vertex& q2 ){
  double d=0;

  // TODO compute a distance between two configurations (your choice of metric).
  //  sqrt(q1 - q2)? first three joints, last three joints weights?
  double weight;
  for(int i = 0; i < 6; i++){
      weight = (7-i)/21; // I set the weight inversely proportional to the index of joints
      d += sqrt(abs(q1[i] - q2[i]));
  }
  return d;
}

// TODO
Node CS436Context::nearest_configuration( const CS436Context::vertex& q_rand, Node * root){
  CS436Context::vertex q_near;
  Node *q_near_node = newNode(root->data);
  queue<Node *> deque;
  int len;
  double min_distance = CS436Context::distance( root->data, q_rand);
  if (root==NULL)
  {return;}
  deque.push(root);
  while(!deque.empty()){
      len = deque.size();
      while(len > 0){
          Node * candidate = deque.front();
          deque.pop();
          // BFS traverse of the tree
          //candidate->data << " ";
          double candidate_distance = CS436Context::distance( candidate->data, q_rand);
          if(candidate_distance < min_distance){
              q_near_node = candidate;
          }

          // Enqueue all children of the dequeued item
          for (int i=0; i<candidate->child.size(); i++)
              deque.push(candidate->child[i]);
          len--;

      }
  }
  return q_near_node;
}

// TODO
bool CS436Context::is_subpath_collision_free( const CS436Context::vertex& q_near,
					      const CS436Context::vertex& q_rand ){
  // TODO find if the straightline path between q_near and q_rand is collision free
  // Determine if a straight line path is collision-free between two configurations.
  // \input q_near The first configuration
  // \input q_rand The second configuration
  // \return True if the path is collision-free. False otherwise.
  CS436Context::vertex q_aux;
  for(double t = 0.05; t < 1; t += 0.05 ){
      q_aux = CS436Context::interpolate(q_near, q_rand, t);
      if (CS436Context::is_colliding( q_aux )){
          return false;
      }
  }
  return true;
}


// TODO
CS436Context::path CS436Context::search_path( const CS436Context::vertex& q_init,
					      const CS436Context::vertex& q_goal, Node * root, int Lpath, CS436Context::path P){
    // TODO Once q_goal has been added to the tree, find the path (sequence of configurations) between
    // q_init and q_goal
    // question: how to make sure the path between q_rand and q_goal is collision free???
    CS436Context::path result
  bool IsLeaf = true;

  if (root == NULL)
      return;
  P.push_back(root->data);
  Lpath ++;

  for(int i = 0; i < root->child.size(); i++){
      if (root->child[i] != NULL){
          IsLeaf = false;
      }
  }
  if(IsLeaf == true){
      result = CS436Context::search_path(q_init, q_goal, root, Lpath, P);
  }
  else{
      for(int i = 0; i < root->child.size(); i++){
          result = CS436Context::search_path(q_init, q_goal, root->child[i], Lpath, P);
      }

  }

  if(result.back()->data == q_goal){
      return result;
  }
}

// TODO
CS436Context::path CS436Context::rrt( const CS436Context::vertex& q_init,
				      const CS436Context::vertex& q_goal ){
  CS436Context::path P;
  // TODO build and expand a RRT tree and return the path
    CS436Context::vertex q_new;
    CS436Context::vertex q_rand;
    CS436Context::vertex q_near;
    CS436Context::path path_candidate;
    int i = 1;

    // initialize tree
    Node *root = newNode(q_init);
    Node *q_near_node = newNode(q_init);

    while(CS436Context::distance( q_new, q_goal) > 0.01){

        // select configuration from tree
        q_rand = CS436Context::random_sample( q_goal );
        q_near_node = CS436Context::nearest_configuration(q_rand, root);

        // add new branch to tree from selected configuration
        q_new = CS436Context::interpolate( q_near_node->data, q_rand, 0.1 );
        while (CS436Context::is_subpath_collision_free(q_new, q_rand)){
            ( q_near_node->child).push_back(newNode(q_new));
            i ++;
            q_new = CS436Context::interpolate( q_near_node->data, q_rand, 0.1 * i);
        }
    }
    P = CS436Context::search_path(q_init, q_goal, root, 0, P);
    return P;
}

// This is the method that is called each time a plan is requested
// You cannot modify this part.
bool CS436Context::solve( planning_interface::MotionPlanResponse &res ){

  // Create a new empty trajectory
  res.trajectory_.reset(new robot_trajectory::RobotTrajectory(robotmodel, getGroupName()));
  res.trajectory_->clear();

  // copy the initial/final joints configurations to vectors qfin and qini
  // This is mainly for convenience.
  vertex q_init, q_goal;
  for( size_t i=0; i<robotmodel->getVariableCount(); i++ ){
    q_goal.push_back(request_.goal_constraints[0].joint_constraints[i].position);
    q_init.push_back(request_.start_state.joint_state.position[i]);
  }

  // start the timer
  ros::Time begin = ros::Time::now();

  path P = rrt( q_init, q_goal );

  // end the timer
  ros::Time end = ros::Time::now();

  // The rest is to fill in the animation.
  moveit::core::RobotState robotstate( robotmodel );
  robotstate.setJointGroupPositions( "manipulator", q_init );

  for( std::size_t i=P.size()-1; i>=1; i-- ){
    for( double t=0.0; t<=1.0; t+=0.01 ){
      vertex q = interpolate( P[i], P[i-1], t );
      robotstate.setJointGroupPositions( "manipulator", q );
      res.trajectory_->addSuffixWayPoint( robotstate, 0.01 );
    }
  }
  
  // set the planning time
  ros::Duration duration = end-begin;
  res.planning_time_ = duration.toSec();
  res.error_code_.val = moveit_msgs::MoveItErrorCodes::SUCCESS;

  return true;
  
}

bool CS436Context::solve( planning_interface::MotionPlanDetailedResponse &res )
{ return true; }

void CS436Context::clear(){}

bool CS436Context::terminate(){return true;}
