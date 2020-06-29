<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Enqueue\RdKafka\RdKafkaConnectionFactory;

class ProducerController extends Controller
{
    public function __construct()
    {
        ini_set('max_execution_time', 700);
    }

    public function sendMessage()
    {
        $connectionFactory = new RdKafkaConnectionFactory([
            'global' => [
                'group.id' => uniqid('', true),
                'metadata.broker.list' => 'broker:9092',
                'enable.auto.commit' => 'true',
            ],
            'topic' => [
                'auto.offset.reset' => 'beginning',
            ],
        ]);

        $context = $connectionFactory->createContext();
        $message = $context->createMessage('Testing Halo');
        $fooTopic = $context->createTopic('helloworld');

        $context->createProducer()->send($fooTopic, $message);

        return 'success';
    }
}
